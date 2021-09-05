#![feature(path_try_exists)]
//! This package is used to symlink the first level of a directory to the home root. This is useful
//! specifically for installing the configurations located in this directory to the user.

use std::os::unix::fs::symlink;
use std::collections::HashSet;
use std::path::{PathBuf, Path};

fn main() {
    let src_dir = {
        let mut args = std::env::args_os();
        if args.len() != 2 {
            println!("Received {:?} args. Not going to do anything, since I don't understand this.", args);
            return;
        }
        let _ = args.next(); // Forget the executable name.
        // Already checked length, so can unwrap `args.next()` without worry.
        let given = PathBuf::from(args.next().unwrap());
        let dir = match given.as_path().canonicalize() {
            Ok(p) => p,
            Err(e) => {
                println!("Could not canonicalize provided path {:?} due to {:?}.", given, e);
                return;
            },
        };
        if !dir.is_dir() {
            println!("Could not determine if provided path {:?} is a directory. Terminating.", dir);
            return;
        }
        dir
    };

    let (entries_to_link, entry_names) = {
        let ff_iter = match src_dir.read_dir() {
            Ok(ff) => ff,
            Err(e) => {
                println!("Attempting to iterate over the contents of {:?} has failed due to {:?}.", src_dir, e);
                return;
            },
        };
        let mut ff = vec![];
        let mut ff_names = HashSet::new();
        let mut should_terminate = false;
        for res_f in ff_iter {
            match res_f {
                Ok(f) => {
                    ff_names.insert(f.file_name());
                    ff.push(f);
                },
                Err(e) => {
                    // Log and continue.
                    println!("Could not iterate over next file due to {:?}.", e);
                    should_terminate = true;
                },
            }
        }
        println!("Directory iteration found following files: {:?}", ff);
        if should_terminate {
            println!("Found files that could not be read in the source directory. Please fix these issues before proceeding.");
            return;
        }
        (ff, ff_names)
    };

    let dst_dir = {
        let h = home::home_dir();
        let dir = match h.as_ref().map(|p| p.as_path().canonicalize()) {
            Some(Ok(p)) => p,
            None => {
                println!("Could not locate home directory.");
                return;
            },
            Some(Err(e)) => {
                println!("Could not canonicalize provided path {:?} due to {:?}.", h, e);
                return;
            },
        };
        if !dir.is_dir() {
            println!("Could not determine if provided path {:?} is a directory. Terminating.", dir);
            return;
        }
        dir
    };

    let entries_to_del = {
        let ff_iter = match src_dir.read_dir() {
            Ok(ff) => ff,
            Err(e) => {
                println!("Attempting to iterate over the contents of {:?} has failed due to {:?}.", src_dir, e);
                return;
            },
        };
        match dst_dir.metadata() {
            Ok(m) => {
                if m.permissions().readonly() {
                    println!("Will not be able to modify destination directory {:?}. Terminating.", dst_dir);
                    return;
                }
            },
            Err(e) => {
                println!("Could not access metadata of {:?} due to {:?}.", dst_dir, e);
                return;
            },
        }
        let mut ff = vec![];
        let mut should_terminate = false;
        for res_f in ff_iter {
            match res_f {
                Ok(f) => {
                    let f_name = f.file_name();
                    if entry_names.contains(&f_name) {
                        let fm = match f.metadata() {
                            Ok(fm) => fm,
                            Err(e) => {
                                println!("Could not access metadata of {:?} due to {:?}.", f, e);
                                should_terminate = true;
                                continue;
                            },
                        };
                        if fm.permissions().readonly() {
                            println!("Will not be able to delete {:?} due to restricted permissions.", f);
                            should_terminate = true;
                            continue;
                        }
                        ff.push((f, fm));
                    }
                },
                Err(e) => {
                    // Log and continue.
                    println!("Could not iterate over next file due to {:?}.", e);
                    should_terminate = true;
                },
            }
        }
        println!("Directory iteration found following files: {:?}", ff);
        if should_terminate {
            println!("Found files that could not be read in the destination directory. Please fix these issues before proceeding.");
            return;
        }
        ff
    };

    println!("WARNING! RUNNING THIS UTILITY WILL DELETE ALL RELEVANT DOTFILES/FOLDERS THAT ARE PRESENT WITHIN THE HOME DIRECTORY.");
    println!("Here is the list of files to be replaced:");
    for (f, _) in &entries_to_del {
        println!("\t{:?}", f.path());
    }
    println!("The source of the replacement is from {:?}.", src_dir);
    println!("The location of the deleted files is {:?}.", dst_dir);
    println!("Press any key to continue. Ctrl-C to stop.");

    { // This block is for isolating vars in their own namespace.
        let mut input = String::new();
        if let Err(e) = std::io::stdin().read_line(&mut input) {
            println!("Something with the requested confirmation went wrong due to {:?}. Terminating.", e);
        }
    }

    for (f, fm) in entries_to_del {
        let del_res = if fm.file_type().is_dir() {
            std::fs::remove_dir_all(f.path())
        } else {
            std::fs::remove_file(f.path())
        };
        if let Err(e) = del_res {
            println!("Could not delete directory entry {:?} due to {:?}.", f, e);
            return;
        }
    }

    for entry in entries_to_link {
        let mut new_link = dst_dir.clone();
        new_link.push(entry.file_name());
        let new_link = new_link;
        if let Err(e) = symlink(entry.path(), new_link.as_path()) {
            println!("Failed to create symlink to {:?} from {:?} due to {:?}. Not stopping.", entry.path(), new_link, e);
        };
    }

    println!("Process completed. Have a good day.");
}
