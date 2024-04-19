//
//  patchfind.c
//  beepserv-installer
//
//  Created by Alfie on 22/03/2024.
//

#include "patchfind.h"
#include <time.h>
#include <sys/mman.h>

#include <libjailbreak/info.h>
#include <libjailbreak/translation.h>

xpc_object_t _systemInfoXdict;

bool initialise_kernel_info(const char *kernelPath, bool iOS14) {
    if (!iOS14) {
        int r = xpf_start_with_kernel_path(kernelPath);
        if (r == 0) {
            char *sets[] = {
                "translation",
                "trustcache",
                "sandbox",
                "physmap",
                "struct",
                "physrw",
                "perfkrw",
                NULL,
                NULL,
                NULL,
            };
            
            uint32_t idx = 7;
            if (xpf_set_is_supported("devmode")) {
                sets[idx++] = "devmode";
            }
            
            _systemInfoXdict = xpf_construct_offset_dictionary((const char **)sets);
            if (_systemInfoXdict) {
                xpc_dictionary_set_uint64(_systemInfoXdict, "kernelConstant.staticBase", gXPF.kernelBase);
                printf("System Info:\n");
                xpc_dictionary_apply(_systemInfoXdict, ^bool(const char *key, xpc_object_t value) {
                    if (xpc_get_type(value) == XPC_TYPE_UINT64) {
                        printf("0x%016llx <- %s\n", xpc_uint64_get_value(value), key);
                    }
                    return true;
                });
            }
            if (!_systemInfoXdict) {
                return false;
            }
            xpf_stop();
        } else {
            xpf_stop();
            return false;
        }
        
        jbinfo_initialize_dynamic_offsets(_systemInfoXdict);
    }
    
    jbinfo_initialize_hardcoded_offsets();
    
    if (!iOS14) {
        _systemInfoXdict = jbinfo_get_serialized();
        
        if (_systemInfoXdict) {
            printf("System Info libjailbreak:\n");
            xpc_dictionary_apply(_systemInfoXdict, ^bool(const char *key, xpc_object_t value) {
                if (xpc_get_type(value) == XPC_TYPE_UINT64) {
                    if (xpc_uint64_get_value(value)) {
                        printf("0x%016llx <- %s\n", xpc_uint64_get_value(value), key);
                    }
                }
                return true;
            });
        }
    }
    
    return true;
}
