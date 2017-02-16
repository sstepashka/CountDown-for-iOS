//
//  helper.h
//  CountDown
//
//  Created by Kuragin Dmitriy on 16/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

#ifndef swift_h
#define swift_h

#include <stdio.h>
#include <pocketsphinx/pocketsphinx.h>

#ifdef __cplusplus
extern "C" {
#endif

cmd_ln_t *cmd_ln_init_swift(cmd_ln_t *inout_cmdln, arg_t const *defn, int32 strict, va_list args);

#ifdef __cplusplus
} /* extern "C" */
#endif
    
#endif /* swift_h */
