//
//  helper.c
//  CountDown
//
//  Created by Kuragin Dmitriy on 16/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

#include "swift.h"
#include "sphinxbase/cmd_ln.h"
#include <sys/_types/_va_list.h>

cmd_ln_t *cmd_ln_init_swift(cmd_ln_t *inout_cmdln, arg_t const *defn, int32 strict, va_list args) {
    return cmd_ln_init(inout_cmdln, defn, strict, args);
}
