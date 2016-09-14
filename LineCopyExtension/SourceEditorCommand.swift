//
//  SourceEditorCommand.swift
//  LineCopyExtension
//
//  Created by 平塚 俊輔 on 2016/09/10.
//  Copyright © 2016年 平塚 俊輔. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        var addLine: [NSString] = []
        var lastIndex: Int = 0

        /// まずは選択したところを取得するところから
        if invocation.buffer.selections.count > 0{
            // 1. Find lines that contain a closure syntax
            for lineIndex in 0 ..< invocation.buffer.selections.count {
                guard let selection = invocation.buffer.selections[lineIndex] as? XCSourceTextRange else{
                    completionHandler(NSError(domain: "SampleExtension", code: -1, userInfo: [NSLocalizedDescriptionKey: "None selection"]))
                    return
                }
                
                for index in selection.start.line ... selection.end.line {
                    guard let line = invocation.buffer.lines[index] as? NSString else {
                        continue
                    }
                    addLine.append(line)
                    
                    // 最後に選択したindexを保持しておく
                    lastIndex = index
                }
            }
            
            
            
            // 次に現在選択してるところに追加していく
            
            // 最後のindexのオブジェクトを取得
            if !addLine.isEmpty{
                for addlineStr in addLine{
                    lastIndex += 1
                    invocation.buffer.lines.insert(addlineStr, at: lastIndex)
                }
            }
            
            
            
        }
        
        
        completionHandler(nil)
    }
    
}
