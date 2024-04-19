//
//  install.h
//  beepserv-installer
//
//  Created by Alfie on 22/03/2024.
//

#ifndef install_h
#define install_h

NSString *find_path_for_app(NSString *appName);
bool install_trollstore(NSString *tar);
bool install_ldid(NSString *path);
bool install_beepserv(NSString *ipa);
bool install_persistence_helper(NSString *app);

#endif /* install_h */
