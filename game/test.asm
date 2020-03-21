;♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥;      
;♥ .      _ _  __   .                                               ♥;
;♥     * ( | )/_/       ; Minimal NES                               ♥;
;♥  . __( >O< )    *                                                ♥;
;♥    \_\(_|_)  +                                                   ♥;
;♥  +       .         .                                             ♥;
;♥                      ; Rachel Simone Weil                        ♥;
;♥                      ; http://nobadmemories.com                  ♥;
;♥                      ; http://github.com/hxlnt                   ♥;
;♥                                                                  ♥;
;♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥;

                                                        
;;;;;;;; + 1.0 NESASM3.0 HEADER + ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      
                                                                    ;;
    .inesprg 1          ; 2 16-KB banks PRG data (32KB total)       ;;
    .ineschr 1          ; 1 8-KB bank CHR data (8KB total)          ;;
    .inesmap 0          ; No mapper                                 ;;
    .inesmir 0          ; Vertical mirroring                        ;;
                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;; + 2.0 VARIABLES + ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;
    .rsset $0000        ; Start variables at $0000 (zero page)      ;;          
framecounter    .rs 1   ; General-purpose frame counter             ;;
                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;; + 3.0 GAME CODE: BANK 0 + ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;
    .bank 0             ; Bank 0                                    ;;
    .org $8000          ; begins at address $8000                   ;;
                                                                    ;;
;;;;;;;;;; 3.1 Console initialization ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;
Reset:                  ; This code runs when console is reset      ;;
    SEI                                                             ;;
    CLD                                                             ;;
    LDX #$40                                                        ;;
    STX $4017                                                       ;;
    LDX #$FF                                                        ;;
    TXS                                                             ;;
    INX                                                             ;;
    STX $2000                                                       ;;
    STX $2001                                                       ;;
    STX $4010                                                       ;;
Vblank1:                ; Wait for first V-blank                    ;;
    BIT $2002                                                       ;;
    BPL Vblank1                                                     ;;
ClearMem:               ; Clear memory                              ;;                    
    LDA #$00                                                        ;;
    STA $0000, x                                                    ;;
    STA $0100, x                                                    ;;
    STA $0300, x                                                    ;;
    STA $0400, x                                                    ;;
    STA $0500, x                                                    ;;
    STA $0600, x                                                    ;;
    STA $0700, x                                                    ;;
    LDA #$FE                                                        ;;
    STA $0200, x                                                    ;;
    INX                                                             ;;
    BNE ClearMem                                                    ;;
Vblank2:                ; Wait for second V-blank                   ;;
    BIT $2002                                                       ;;
    BPL Vblank2                                                     ;; 
                                                                    ;;
;;;;;;;;;; 3.2 Game initialization ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;  
    LDA #$00            ; Reset framecounter                        ;;
    STA framecounter                                                ;;
    JSR TurnScreenOff   ; Disable screen rendering                  ;;
    JSR LoadBG          ; Load background                           ;;
    JSR TurnScreenOn    ; Enable screen rendering                   ;;
                                                                    ;;
;;;;;;;;;; 3.3 Game loop ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;
GameLoop:                                                           ;;
    JMP GameLoop                                                    ;;
                                                                    ;;
;;;;;;;;;; 3.4 NMI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;
NMI:                    ; Non-maskable interrupt                    ;;
    PHA                 ; Back up registers                         ;;
    TXA                                                             ;;
    PHA                                                             ;;
    TYA                                                             ;;
    PHA                                                             ;;
    LDX framecounter    ; Add one to the frame counter              ;;
    INX                                                             ;;
    STX framecounter                                                ;;
NMIDone:                ; Final actions in NMI                      ;;
	LDA #$00            ; X- and Y-scrolling set to 0               ;;
	STA $2005                                                       ;;
	STA $2005                                                       ;;
	JSR TurnScreenOn    ; Turn screen on                            ;;
    PLA                 ; Restore registers                         ;;
    TAY                                                             ;;
    PLA                                                             ;;
    TAX                                                             ;;
    PLA                                                             ;;
    RTI                 ; NMI is done                               ;;
                                                                    ;;
;;;;;;;;;; 3.5 Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;
LoadDefaultPal:         ; "Load Default palette" subroutine         ;;
    LDA $2002                                                       ;;
    LDA #$3F                                                        ;;
    STA $2006                                                       ;;
    LDA #$00                                                        ;;
    STA $2006                                                       ;;
    LDX #$00                                                        ;;
LoadDefaultPalLoop:                                                 ;;
    LDA defaultpal, x                                               ;;
    STA $2007                                                       ;;
    INX                                                             ;;
    CPX #$20                                                        ;;
    BNE LoadDefaultPalLoop                                          ;;
    RTS                                                             ;;
LoadBG:                 ; "Load background" subroutine              ;;
    LDA $2002                                                       ;;
    LDA #$3F                                                        ;;
    STA $2006                                                       ;;
    LDA #$00                                                        ;;
    STA $2006                                                       ;;
    LDX #$00                                                        ;;
LoadPalLoop:            ; Default palette is loaded on reset        ;;
    LDA defaultpal, x                                               ;;
    STA $2007                                                       ;;
    INX                                                             ;;
    CPX #$20                                                        ;;
    BNE LoadPalLoop                                                 ;;
    LDA $2002                                                       ;;
    LDA #$20                                                        ;;
    STA $2006                                                       ;;
    LDA #$00                                                        ;;
    STA $2006                                                       ;;
    LDX #$00                                                        ;;
LoadTitleNewNam1:       ; Load first set of 256 background tiles    ;;
    LDA background1,x                                               ;;
    STA $2007                                                       ;;
    INX                                                             ;;
    BNE LoadTitleNewNam1                                            ;;
LoadTitleNewNam2:       ; Load second set of 256 background tiles   ;;
    LDA background2,x                                               ;;
    STA $2007                                                       ;;
    INX                                                             ;;
    BNE LoadTitleNewNam2                                            ;;
LoadTitleNewNam3:       ; Load third set of 256 background tiles    ;;
    LDA background3,x                                               ;;
    STA $2007                                                       ;;
    INX                                                             ;;
    BNE LoadTitleNewNam3                                            ;;
LoadTitleNewNam4:       ; Load fourth set of background tiles       ;;
    LDA background4,x                                               ;;
    STA $2007                                                       ;;
    INX                                                             ;;
    CPX #$E0            ; (Don't have to load all 256)              ;;
    BNE LoadTitleNewNam4                                            ;;
LoadAttr:               ; Load initial attribute values for BG      ;;
    LDA #$23                                                        ;;
    STA $2006                                                       ;;
    LDA #$c0                                                        ;;
    STA $2006                                                       ;;
    LDX #$00                                                        ;;
LoadAttrLoop:                                                       ;;
    LDA attr, x                                                     ;;
    STA $2007                                                       ;;
    INX                                                             ;;
    CPX #$40                                                        ;;
    BNE LoadAttrLoop                                                ;;
    RTS                                                             ;;
TurnScreenOn:           ; Enable screen rendering                   ;;
    LDA #%10010000                                                  ;;
    STA $2000                                                       ;;
    LDA #%00011010                                                  ;;
    STA $2001                                                       ;;
    RTS                                                             ;;
TurnScreenOff:          ; Disable screen rendering                  ;;
    LDA #$00                                                        ;;
    STA $2000                                                       ;;
    STA $2001                                                       ;;
    RTS                                                             ;;
                                                                    ;;
;;;;;;;;;; 3.6 Binary data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;

background1:            ; First 256-tile set of background          ;;
    .db $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00 
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db "NES-PIPELINE"
    .db $00,$00,$E0,$00,$00,$00
    .db "MAR 21, 2020"
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
    .db $00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
    .db $03,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00 
    .db $00,$00,$00,$00,$03,$00,$00
    .db "11:20 PM"
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00 
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00 
    .db $00,$D7,$D8,$00,$00,$B7,$00,$00,$00,$00,$00,$00,$03,$00,$00,$03 
    .db $00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$D7,$D8,$00,$00,$00,$00 
    .db $00,$D9,$DA,$00,$00,$79,$77,$00,$00,$00,$00,$00,$00,$00,$00,$00 
    .db $00,$00,$00,$00,$00,$B7,$77,$00,$00,$00,$D9,$DA,$00,$00,$00,$00
background2:            ; Second 256-tile set of background         ;;
    .incbin "pipeline2.nam"                                    ;;
background3:            ; Third 256-tile set of background          ;;
    .incbin "pipeline3.nam"                                    ;;
background4:            ; Third 256-tile set of background          ;;
    .incbin "pipeline4.nam"                                    ;;
defaultpal:             ; Default color palette                     ;;
    .incbin "pipeline.pal" 					        					;;
attr:                   ; Color attribute table                     ;;
    .incbin "pipeline.atr"												;;
                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    

;;;;;;;; + 4.0 VECTORS: BANK 1 + ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;
    .bank 1             ; Bank 1                                    ;;
    .org $E000          ; Begins at memory address $E000            ;;
    .org $FFFA          ; Final three bytes (vectors):              ;;
    .dw NMI             ; When an NMI happens, jump to NMI          ;;
    .dw Reset           ; On reset/power on, jump to Reset          ;;
    .dw 0               ; IRQ disabled                              ;;
                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
  
;;;;;;;; + 5.0 GRAPHICS DATA: BANK 2 + ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                    ;;
    .bank 2             ; Bank 2                                    ;;
    .org $0000          ; Starts at $0000 (CHR)                     ;;
    .incbin "ascii.chr" ; Include graphics binary                   ;;
                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
