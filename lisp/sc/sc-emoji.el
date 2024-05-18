;; https://www.unicode.org/Public/15.1.0/ucd/emoji/emoji-data.txt

;; Note that some character will not be overriden by emoji, e.g. #x0023, #x002A, (#x0030 . #x0039), #x00A9, #x00AE
;; even if they are not commented, this because
;; 1. They are in default font and Emacs will use default face's font for displaying them disregarding the fontsets.
;; 2. They are not in script 'symbol, so even if set use-default-font-for-symbols to nil, they will not be overriden.
;; Which means that there would still be problem for showing emojis, e.g. keycap sequences 

;; By default, Emacs will try to use the default face's font for
;; displaying symbol and punctuation characters, disregarding the
;; fontsets, if the default font can display the character.
;; Set this to nil to make Emacs honor the fontsets instead.

(defvar sc-emoji-charsets
  '(
    ;; Emoji_Modifier
    (#x1F3FB . #x1F3FF)
    
    ;; Emoji_Component
    ;; #x0023 ; hash sign
    ;; #x002A ; asterisk
    ;; (#x0030 . #x0039) ; digit zero..digit nine
    #x200D ; zero width joiner
    #x20E3 ; combining enclosing keycap
    #xFE0F ; VARIATION SELECTOR-16
    (#x1F1E6 . #x1F1FF) ; regional indicator symbol letter a..regional indicator symbol letter z
    (#x1F3FB . #x1F3FF) ; light skin tone..dark skin tone
    (#x1F9B0 . #x1F9B3) ; red hair..white hair
    (#xE0020 . #xE007F) ; tag space..cancel tag
    
    ;; Extended_Pictographic
    ;; #x00A9 ; copyright
    ;; #x00AE ; registered
    #x203C
    #x2049
    #x2122
    #x2139
    (#x2194 . #x2199)
    (#x21A9 . #x21AA)
    (#x231A . #x231B)
    #x2328
    #x2388
    #x23CF
    (#x23E9 . #x23EC)
    (#x23ED . #x23EE)
    #x23EF
    #x23F0
    (#x23F1 . #x23F2)
    #x23F3
    (#x23F8 . #x23FA)
    #x24C2
    (#x25AA . #x25AB)
    #x25B6
    #x25C0
    (#x25FB . #x25FE)
    (#x2600 . #x2601)
    (#x2602 . #x2603)
    #x2604
    #x2605
    (#x2607 . #x260D)
    #x260E
    (#x260F . #x2610)
    #x2611
    #x2612
    (#x2614 . #x2615)
    (#x2616 . #x2617)
    #x2618
    (#x2619 . #x261C)
    #x261D
    (#x261E . #x261F)
    #x2620
    #x2621
    (#x2622 . #x2623)
    (#x2624 . #x2625)
    #x2626
    (#x2627 . #x2629)
    #x262A
    (#x262B . #x262D)
    #x262E
    #x262F
    (#x2630 . #x2637)
    (#x2638 . #x2639)
    #x263A
    (#x263B . #x263F)
    #x2640
    #x2641
    #x2642
    (#x2643 . #x2647)
    (#x2648 . #x2653)
    (#x2654 . #x265E)
    #x265F
    #x2660
    (#x2661 . #x2662)
    #x2663
    #x2664
    (#x2665 . #x2666)
    #x2667
    #x2668
    (#x2669 . #x267A)
    #x267B
    (#x267C . #x267D)
    #x267E
    #x267F
    (#x2680 . #x2685)
    (#x2690 . #x2691)
    #x2692
    #x2693
    #x2694
    #x2695
    (#x2696 . #x2697)
    #x2698
    #x2699
    #x269A
    (#x269B . #x269C)
    (#x269D . #x269F)
    (#x26A0 . #x26A1)
    (#x26A2 . #x26A6)
    #x26A7
    (#x26A8 . #x26A9)
    (#x26AA . #x26AB)
    (#x26AC . #x26AF)
    (#x26B0 . #x26B1)
    (#x26B2 . #x26BC)
    (#x26BD . #x26BE)
    (#x26BF . #x26C3)
    (#x26C4 . #x26C5)
    (#x26C6 . #x26C7)
    #x26C8
    (#x26C9 . #x26CD)
    #x26CE
    #x26CF
    #x26D0
    #x26D1
    #x26D2
    #x26D3
    #x26D4
    (#x26D5 . #x26E8)
    #x26E9
    #x26EA
    (#x26EB . #x26EF)
    (#x26F0 . #x26F1)
    (#x26F2 . #x26F3)
    #x26F4
    #x26F5
    #x26F6
    (#x26F7 . #x26F9)
    #x26FA
    (#x26FB . #x26FC)
    #x26FD
    (#x26FE . #x2701)
    #x2702
    (#x2703 . #x2704)
    #x2705
    (#x2708 . #x270C)
    #x270D
    #x270E
    #x270F
    (#x2710 . #x2711)
    #x2712
    #x2714
    #x2716
    #x271D
    #x2721
    #x2728
    (#x2733 . #x2734)
    #x2744
    #x2747
    #x274C
    #x274E
    (#x2753 . #x2755)
    #x2757
    #x2763
    #x2764
    (#x2765 . #x2767)
    (#x2795 . #x2797)
    #x27A1
    #x27B0
    #x27BF
    (#x2934 . #x2935)
    (#x2B05 . #x2B07)
    (#x2B1B . #x2B1C)
    #x2B50
    #x2B55
    #x3030
    #x303D
    #x3297
    #x3299
    (#x1F000 . #x1F003)
    #x1F004
    (#x1F005 . #x1F0CE)
    #x1F0CF
    (#x1F0D0 . #x1F0FF)
    (#x1F10D . #x1F10F)
    #x1F12F
    (#x1F16C . #x1F16F)
    (#x1F170 . #x1F171)
    (#x1F17E . #x1F17F)
    #x1F18E
    (#x1F191 . #x1F19A)
    (#x1F1AD . #x1F1E5)
    (#x1F201 . #x1F202)
    (#x1F203 . #x1F20F)
    #x1F21A
    #x1F22F
    (#x1F232 . #x1F23A)
    (#x1F23C . #x1F23F)
    (#x1F249 . #x1F24F)
    (#x1F250 . #x1F251)
    (#x1F252 . #x1F2FF)
    (#x1F300 . #x1F30C)
    (#x1F30D . #x1F30E)
    #x1F30F
    #x1F310
    #x1F311
    #x1F312
    (#x1F313 . #x1F315)
    (#x1F316 . #x1F318)
    #x1F319
    #x1F31A
    #x1F31B
    #x1F31C
    (#x1F31D . #x1F31E)
    (#x1F31F . #x1F320)
    #x1F321
    (#x1F322 . #x1F323)
    (#x1F324 . #x1F32C)
    (#x1F32D . #x1F32F)
    (#x1F330 . #x1F331)
    (#x1F332 . #x1F333)
    (#x1F334 . #x1F335)
    #x1F336
    (#x1F337 . #x1F34A)
    #x1F34B
    (#x1F34C . #x1F34F)
    #x1F350
    (#x1F351 . #x1F37B)
    #x1F37C
    #x1F37D
    (#x1F37E . #x1F37F)
    (#x1F380 . #x1F393)
    (#x1F394 . #x1F395)
    (#x1F396 . #x1F397)
    #x1F398
    (#x1F399 . #x1F39B)
    (#x1F39C . #x1F39D)
    (#x1F39E . #x1F39F)
    (#x1F3A0 . #x1F3C4)
    #x1F3C5
    #x1F3C6
    #x1F3C7
    #x1F3C8
    #x1F3C9
    #x1F3CA
    (#x1F3CB . #x1F3CE)
    (#x1F3CF . #x1F3D3)
    (#x1F3D4 . #x1F3DF)
    (#x1F3E0 . #x1F3E3)
    #x1F3E4
    (#x1F3E5 . #x1F3F0)
    (#x1F3F1 . #x1F3F2)
    #x1F3F3
    #x1F3F4
    #x1F3F5
    #x1F3F6
    #x1F3F7
    (#x1F3F8 . #x1F3FA)
    (#x1F400 . #x1F407)
    #x1F408
    (#x1F409 . #x1F40B)
    (#x1F40C . #x1F40E)
    (#x1F40F . #x1F410)
    (#x1F411 . #x1F412)
    #x1F413
    #x1F414
    #x1F415
    #x1F416
    (#x1F417 . #x1F429)
    #x1F42A
    (#x1F42B . #x1F43E)
    #x1F43F
    #x1F440
    #x1F441
    (#x1F442 . #x1F464)
    #x1F465
    (#x1F466 . #x1F46B)
    (#x1F46C . #x1F46D)
    (#x1F46E . #x1F4AC)
    #x1F4AD
    (#x1F4AE . #x1F4B5)
    (#x1F4B6 . #x1F4B7)
    (#x1F4B8 . #x1F4EB)
    (#x1F4EC . #x1F4ED)
    #x1F4EE
    #x1F4EF
    (#x1F4F0 . #x1F4F4)
    #x1F4F5
    (#x1F4F6 . #x1F4F7)
    #x1F4F8
    (#x1F4F9 . #x1F4FC)
    #x1F4FD
    #x1F4FE
    (#x1F4FF . #x1F502)
    #x1F503
    (#x1F504 . #x1F507)
    #x1F508
    #x1F509
    (#x1F50A . #x1F514)
    #x1F515
    (#x1F516 . #x1F52B)
    (#x1F52C . #x1F52D)
    (#x1F52E . #x1F53D)
    (#x1F546 . #x1F548)
    (#x1F549 . #x1F54A)
    (#x1F54B . #x1F54E)
    #x1F54F
    (#x1F550 . #x1F55B)
    (#x1F55C . #x1F567)
    (#x1F568 . #x1F56E)
    (#x1F56F . #x1F570)
    (#x1F571 . #x1F572)
    (#x1F573 . #x1F579)
    #x1F57A
    (#x1F57B . #x1F586)
    #x1F587
    (#x1F588 . #x1F589)
    (#x1F58A . #x1F58D)
    (#x1F58E . #x1F58F)
    #x1F590
    (#x1F591 . #x1F594)
    (#x1F595 . #x1F596)
    (#x1F597 . #x1F5A3)
    #x1F5A4
    #x1F5A5
    (#x1F5A6 . #x1F5A7)
    #x1F5A8
    (#x1F5A9 . #x1F5B0)
    (#x1F5B1 . #x1F5B2)
    (#x1F5B3 . #x1F5BB)
    #x1F5BC
    (#x1F5BD . #x1F5C1)
    (#x1F5C2 . #x1F5C4)
    (#x1F5C5 . #x1F5D0)
    (#x1F5D1 . #x1F5D3)
    (#x1F5D4 . #x1F5DB)
    (#x1F5DC . #x1F5DE)
    (#x1F5DF . #x1F5E0)
    #x1F5E1
    #x1F5E2
    #x1F5E3
    (#x1F5E4 . #x1F5E7)
    #x1F5E8
    (#x1F5E9 . #x1F5EE)
    #x1F5EF
    (#x1F5F0 . #x1F5F2)
    #x1F5F3
    (#x1F5F4 . #x1F5F9)
    #x1F5FA
    (#x1F5FB . #x1F5FF)
    #x1F600
    (#x1F601 . #x1F606)
    (#x1F607 . #x1F608)
    (#x1F609 . #x1F60D)
    #x1F60E
    #x1F60F
    #x1F610
    #x1F611
    (#x1F612 . #x1F614)
    #x1F615
    #x1F616
    #x1F617
    #x1F618
    #x1F619
    #x1F61A
    #x1F61B
    (#x1F61C . #x1F61E)
    #x1F61F
    (#x1F620 . #x1F625)
    (#x1F626 . #x1F627)
    (#x1F628 . #x1F62B)
    #x1F62C
    #x1F62D
    (#x1F62E . #x1F62F)
    (#x1F630 . #x1F633)
    #x1F634
    #x1F635
    #x1F636
    (#x1F637 . #x1F640)
    (#x1F641 . #x1F644)
    (#x1F645 . #x1F64F)
    #x1F680
    (#x1F681 . #x1F682)
    (#x1F683 . #x1F685)
    #x1F686
    #x1F687
    #x1F688
    #x1F689
    (#x1F68A . #x1F68B)
    #x1F68C
    #x1F68D
    #x1F68E
    #x1F68F
    #x1F690
    (#x1F691 . #x1F693)
    #x1F694
    #x1F695
    #x1F696
    #x1F697
    #x1F698
    (#x1F699 . #x1F69A)
    (#x1F69B . #x1F6A1)
    #x1F6A2
    #x1F6A3
    (#x1F6A4 . #x1F6A5)
    #x1F6A6
    (#x1F6A7 . #x1F6AD)
    (#x1F6AE . #x1F6B1)
    #x1F6B2
    (#x1F6B3 . #x1F6B5)
    #x1F6B6
    (#x1F6B7 . #x1F6B8)
    (#x1F6B9 . #x1F6BE)
    #x1F6BF
    #x1F6C0
    (#x1F6C1 . #x1F6C5)
    (#x1F6C6 . #x1F6CA)
    #x1F6CB
    #x1F6CC
    (#x1F6CD . #x1F6CF)
    #x1F6D0
    (#x1F6D1 . #x1F6D2)
    (#x1F6D3 . #x1F6D4)
    #x1F6D5
    (#x1F6D6 . #x1F6D7)
    (#x1F6D8 . #x1F6DB)
    #x1F6DC
    (#x1F6DD . #x1F6DF)
    (#x1F6E0 . #x1F6E5)
    (#x1F6E6 . #x1F6E8)
    #x1F6E9
    #x1F6EA
    (#x1F6EB . #x1F6EC)
    (#x1F6ED . #x1F6EF)
    #x1F6F0
    (#x1F6F1 . #x1F6F2)
    #x1F6F3
    (#x1F6F4 . #x1F6F6)
    (#x1F6F7 . #x1F6F8)
    #x1F6F9
    #x1F6FA
    (#x1F6FB . #x1F6FC)
    (#x1F6FD . #x1F6FF)
    (#x1F774 . #x1F77F)
    (#x1F7D5 . #x1F7DF)
    (#x1F7E0 . #x1F7EB)
    (#x1F7EC . #x1F7EF)
    #x1F7F0
    (#x1F7F1 . #x1F7FF)
    (#x1F80C . #x1F80F)
    (#x1F848 . #x1F84F)
    (#x1F85A . #x1F85F)
    (#x1F888 . #x1F88F)
    (#x1F8AE . #x1F8FF)
    #x1F90C
    (#x1F90D . #x1F90F)
    (#x1F910 . #x1F918)
    (#x1F919 . #x1F91E)
    #x1F91F
    (#x1F920 . #x1F927)
    (#x1F928 . #x1F92F)
    #x1F930
    (#x1F931 . #x1F932)
    (#x1F933 . #x1F93A)
    (#x1F93C . #x1F93E)
    #x1F93F
    (#x1F940 . #x1F945)
    (#x1F947 . #x1F94B)
    #x1F94C
    (#x1F94D . #x1F94F)
    (#x1F950 . #x1F95E)
    (#x1F95F . #x1F96B)
    (#x1F96C . #x1F970)
    #x1F971
    #x1F972
    (#x1F973 . #x1F976)
    (#x1F977 . #x1F978)
    #x1F979
    #x1F97A
    #x1F97B
    (#x1F97C . #x1F97F)
    (#x1F980 . #x1F984)
    (#x1F985 . #x1F991)
    (#x1F992 . #x1F997)
    (#x1F998 . #x1F9A2)
    (#x1F9A3 . #x1F9A4)
    (#x1F9A5 . #x1F9AA)
    (#x1F9AB . #x1F9AD)
    (#x1F9AE . #x1F9AF)
    (#x1F9B0 . #x1F9B9)
    (#x1F9BA . #x1F9BF)
    #x1F9C0
    (#x1F9C1 . #x1F9C2)
    (#x1F9C3 . #x1F9CA)
    #x1F9CB
    #x1F9CC
    (#x1F9CD . #x1F9CF)
    (#x1F9D0 . #x1F9E6)
    (#x1F9E7 . #x1F9FF)
    (#x1FA00 . #x1FA6F)
    (#x1FA70 . #x1FA73)
    #x1FA74
    (#x1FA75 . #x1FA77)
    (#x1FA78 . #x1FA7A)
    (#x1FA7B . #x1FA7C)
    (#x1FA7D . #x1FA7F)
    (#x1FA80 . #x1FA82)
    (#x1FA83 . #x1FA86)
    (#x1FA87 . #x1FA88)
    (#x1FA89 . #x1FA8F)
    (#x1FA90 . #x1FA95)
    (#x1FA96 . #x1FAA8)
    (#x1FAA9 . #x1FAAC)
    (#x1FAAD . #x1FAAF)
    (#x1FAB0 . #x1FAB6)
    (#x1FAB7 . #x1FABA)
    (#x1FABB . #x1FABD)
    #x1FABE
    #x1FABF
    (#x1FAC0 . #x1FAC2)
    (#x1FAC3 . #x1FAC5)
    (#x1FAC6 . #x1FACD)
    (#x1FACE . #x1FACF)
    (#x1FAD0 . #x1FAD6)
    (#x1FAD7 . #x1FAD9)
    (#x1FADA . #x1FADB)
    (#x1FADC . #x1FADF)
    (#x1FAE0 . #x1FAE7)
    #x1FAE8
    (#x1FAE9 . #x1FAEF)
    (#x1FAF0 . #x1FAF6)
    (#x1FAF7 . #x1FAF8)
    (#x1FAF9 . #x1FAFF)
    (#x1FC00 . #x1FFFD)
    )
  "Emoji code points")

(provide 'sc-emoji)
