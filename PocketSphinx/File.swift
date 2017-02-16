//
//  File.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 16/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import Foundation
import Sphinx

public class Config {
    fileprivate var config: OpaquePointer
    
    public init() {
        config = cmd_ln_init_swift(
            nil,
            ps_args(),
            0,
            getVaList([])
        )
    }
    
    deinit {
        cmd_ln_free_r(config)
    }
}

public class Decoder {
    private var decoder: OpaquePointer
    private let name: String = "keywords"
    
    public init(config: Config, keyphrase: String) {
        decoder = ps_init(config.config)
        ps_set_keyphrase(decoder, name, keyphrase)
        ps_set_search(decoder, keyphrase)
    }
    
    public func process(data: UnsafePointer<int16>, samples: Int) {
        ps_process_raw(
            decoder,
            data,
            samples,
            0,
            0
        )
        
        var score: Int32 = 0
        
        ps_get_hyp(decoder, &score)
    }
    
    private func reset() {
        ps_end_utt(decoder)
        ps_start_utt(decoder)
    }
    
    deinit {
        ps_free(decoder)
    }
}
