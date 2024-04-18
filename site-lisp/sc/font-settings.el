
;; Tip: M-x describe-char can see the character info under cursor

;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Basic-Faces.html
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Attribute-Functions.html#index-set_002dface_002dattribute

;; Set Default Font = Options Set Default Font
;; Note: default-frame-alist Should be consider as a Hashtable not List
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Frame-Parameters.html

;; (add-to-list 'default-frame-alist '(font . "Courier New-10")) ; <-- this is default
;; (add-to-list 'default-frame-alist '(font . "Monospace-10")) ; Courier with Size 10
;; (add-to-list 'default-frame-alist '(font . "Source Code Pro-10"))
;; (add-to-list 'default-frame-alist '(font . "Empty Font-10")) ; Enfore use Empty Font

;; (set-frame-font "Courier New-10")
;; (set-frame-font (font-spec :family
;;                            "Courier New"
;;                            :size 14))


;; If a given family is specified but does not exist, this variable specifies alternative font families to try.
;; Note: It says font family not exist, instead of char not in a font family
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Font-Selection.html

;; ELISP> face-font-family-alternatives
;; (("Monospace" "courier" "fixed")
;;  ("Monospace Serif" "Courier 10 Pitch" "Consolas" "Courier Std" "FreeMono" "Nimbus Mono L" "courier" "fixed")
;;  ("courier" "CMU Typewriter Text" "fixed")
;;  ("Sans Serif" "helv" "helvetica" "arial" "fixed")
;;  ("helv" "helvetica" "arial" "fixed"))

;; ELISP> face-font-registry-alternatives
;; registry can be thought as Codepage
;; (("iso8859-1" "ms-oemlatin") ; iso8859-1 CAN BE THOUGHT AS UTF-8 Codepage in Emacs Font...I guess
;;  ("gb2312.1980" "gb2312" "gbk" "gb18030")
;;  ("jisx0208.1990" "jisx0208.1983" "jisx0208.1978")
;;  ("ksc5601.1989" "ksx1001.1992" "ksc5601.1987")
;;  ("muletibetan-2" "muletibetan-0"))

;; x-list-fonts function returns a list of available font names that match name.
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Font-Lookup.html
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Fonts.html#Fonts
;; -maker-family-weight-slant-widthtype-style……-pixels-height-horiz-vert-spacing-width-registry-encoding

;; ELISP> (x-list-fonts "Source Code Pro")
;; ...

;;  x-family-fonts function returns a list describing the available fonts for family family on frame
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Font-Lookup.html

;; ELISP> (x-family-fonts)
;; ...
;; Each element in the list
;; [family width point-size weight slant
;;  fixed-p full registry-and-encoding]

;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Fontsets.html

;; All defined character set names
;; ELISP> charset-list

;; All defined character set names ordered by their priority
;; ELISP> (charset-priority-list)
;; (unicode-bmp unicode iso-8859-1 chinese-gb2312 ...)

;; Get a's Unicode Spec char property
;; ELISP> (get-char-code-property ?a 'name)
;; "LATIN SMALL LETTER A"
;; ELISP> (get-char-code-property ?🐙 'name)
;; "OCTOPUS"

;; All all script symbols
;; ELISP> char-script-table
;; ELISP> (char-table-extra-slot char-script-table 0)
;; (latin phonetic greek coptic cyrillic armenian hebrew arabic syriac thaana nko samaritan mandaic devanagari bengali gurmukhi gujarati oriya tamil telugu kannada malayalam sinhala thai lao tibetan burmese georgian hangul ethiopic cherokee canadian-aboriginal ogham runic tagalog hanunoo buhid tagbanwa khmer mongolian limbu tai-le tai-lue buginese tai-tham balinese sundanese batak lepcha ol-chiki vedic symbol braille glagolitic tifinagh han ideographic-description cjk-misc kana bopomofo kanbun yi lisu vai bamum syloti-nagri north-indic-number phags-pa saurashtra kayah-li rejang javanese cham tai-viet meetei-mayek vertical-form linear-b aegean-number ancient-greek-number ancient-symbol phaistos-disc lycian carian old-italic gothic old-permic ugaritic old-persian deseret shavian osmanya osage elbasan caucasian-albanian linear-a cypriot-syllabary aramaic palmyrene nabataean hatran phoenician lydian meroitic kharoshthi old-south-arabian old-north-arabian manichaean avestan inscriptional-parthian inscriptional-pahlavi psalter-pahlavi old-turkic old-hungarian hanifi-rohingya rumi-number yezidi old-sogdian sogdian chorasmian elymaic brahmi kaithi sora-sompeng chakma mahajani sharada sinhala-archaic-number khojki multani khudawadi grantha newa tirhuta siddham modi takri ahom dogra warang-citi dives-akuru nandinagari zanabazar-square soyombo pau-cin-hau bhaiksuki marchen masaram-gondi gunjala-gondi makasar cuneiform cuneiform-numbers-and-punctuation egyptian anatolian mro bassa-vah pahawh-hmong medefaidrin miao tangut tangut-components khitan-small-script nushu duployan-shorthand byzantine-musical-symbol musical-symbol ancient-greek-musical-notation mayan-numeral tai-xuan-jing-symbol counting-rod-numeral mathematical sutton-sign-writing nyiakeng-puachue-hmong wancho mende-kikakui adlam indic-siyaq-number ottoman-siyaq-number mahjong-tile domino-tile playing-cards chess-symbol)


;; script-representative-chars
;; ELISP> script-representative-chars
;; ((latin 65 90 97 122 192 256 384 7680)
;;  (phonetic 592 643)
;;  (greek 937)
;;  (coptic 994)
;;  (cyrillic 1071)
;;  (armenian 1329)
;;  (hebrew 1488)
;;  (vai 42240)
;;  (arabic 1576)
;;  (syriac 1808)
;;  (thaana 1932)
;;  (devanagari 2325)
;;  (bengali 2453)
;;  (gurmukhi 2581)
;;  (gujarati 2709)
;;  (oriya 2837)
;;  (tamil 2965)
;;  (telugu 3093)
;;  (kannada 3221)
;;  (malayalam 3349)
;;  (sinhala 3477)
;;  (thai 3607)
;;  (lao 3749)
;;  (tibetan 3904)
;;  (burmese 4096)
;;  (georgian 4307)
;;  (ethiopic 4616)
;;  (cherokee 5046)
;;  (canadian-aboriginal 5312)
;;  (ogham 5775)
;;  (runic 5792)
;;  (khmer 6016)
;;  (mongolian 6182)
;;  (symbol .
;;   [8220 8704 9472])
;;  (braille 10240)
;;  (ideographic-description 12272)
;;  (cjk-misc 12302)
;;  (kana 12363)
;;  (bopomofo 12549)
;;  (kanbun 12701)
;;  (han 23383)
;;  (yi 41608)
;;  (cham 43520)
;;  (tai-viet 43648)
;;  (hangul 44032)
;;  (linear-b 65536)
;;  (aegean-number 65792)
;;  (ancient-greek-number 65856)
;;  (ancient-symbol 65936)
;;  (phaistos-disc 66000)
;;  (lycian 66176)
;;  (carian 66208)
;;  (old-italic 66304)
;;  (ugaritic 66432)
;;  (old-permic 66384)
;;  (old-persian 66464)
;;  (deseret 66560)
;;  (shavian 66640)
;;  (osmanya 66688)
;;  (osage 66736)
;;  (elbasan 66816)
;;  (caucasian-albanian 66864)
;;  (linear-a 67072)
;;  (cypriot-syllabary 67584)
;;  (palmyrene 67680)
;;  (nabataean 67712)
;;  (phoenician 67840)
;;  (lydian 67872)
;;  (kharoshthi 68096)
;;  (manichaean 68288)
;;  (hanifi-rohingya 68864)
;;  (yezidi 69248)
;;  (old-sogdian 69376)
;;  (sogdian 69424)
;;  (chorasmian 69552)
;;  (elymaic 69600)
;;  (mahajani 69968)
;;  (sinhala-archaic-number 70113)
;;  (khojki 70144)
;;  (khudawadi 70320)
;;  (grantha 70405)
;;  (newa 70656)
;;  (tirhuta 70785)
;;  (siddham 71040)
;;  (modi 71168)
;;  (takri 71296)
;;  (dogra 71680)
;;  (warang-citi 71841)
;;  (dives-akuru 71936)
;;  (nandinagari 72096)
;;  (zanabazar-square 72192)
;;  (soyombo 72272)
;;  (pau-cin-hau 72384)
;;  (bhaiksuki 72704)
;;  (marchen 72818)
;;  (masaram-gondi 72960)
;;  (gunjala-gondi 73056)
;;  (makasar 73440)
;;  (cuneiform 73728)
;;  (cuneiform-numbers-and-punctuation 74752)
;;  (egyptian 77824)
;;  (mro 92736)
;;  (bassa-vah 92880)
;;  (pahawh-hmong 92945)
;;  (medefaidrin 93760)
;;  (tangut 94208)
;;  (tangut-components 100352)
;;  (khitan-small-script 101120)
;;  (nushu 110960)
;;  (duployan-shorthand 113696)
;;  (byzantine-musical-symbol 118784)
;;  (musical-symbol 119040)
;;  (ancient-greek-musical-notation 119296)
;;  (tai-xuan-jing-symbol 119552)
;;  (counting-rod-numeral 119648)
;;  (nyiakeng-puachue-hmong 123136)
;;  (wancho 123584)
;;  (mende-kikakui 124944)
;;  (adlam 125184)
;;  (indic-siyaq-number 126065)
;;  (ottoman-siyaq-number 126209)
;;  (mahjong-tile 126976)
;;  (domino-tile 127024)
;;  (mathematical-bold .
;;   [119808 120488 120778])
;;  (mathematical-italic .
;;   [119860 120484 120546])
;;  (mathematical-bold-italic .
;;   [119912 120604])
;;  (mathematical-script 119964)
;;  (mathematical-bold-script 120016)
;;  (mathematical-fraktur 120068)
;;  (mathematical-double-struck .
;;   [120120 120792])
;;  (mathematical-bold-fraktur 120172)
;;  (mathematical-sans-serif .
;;   [120224 120802])
;;  (mathematical-sans-serif-bold .
;;   [120276 120662 120812])
;;  (mathematical-sans-serif-italic 120328)
;;  (mathematical-sans-serif-bold-italic .
;;   [120380 120720])
;;  (mathematical-monospace .
;;   [120432 120822]))

;; M - x list-charset-chars 可以打出 charset/script 里的字符

;; ## Main Font

(set-face-attribute 'default nil :font (font-spec :family "Courier New" :size 14))

;; ## Alternative Font

;; TODO: Note that set-fontset-font can not override character ranges in 'default font'!
;; https://emacs.stackexchange.com/questions/81051/set-fontset-font-can-not-override-character-ranges-in-default-font-set-fac
;; So 'latin and some character in 'symbol will not be overidden ...

;; (dolist (script '(latin phonetic greek coptic cyrillic armenian hebrew))
;;   (set-fontset-font t
;;                     script
;;                     (font-spec :family "Courier New"
;;                                :size 24)
;;                     nil nil))

;; TODO: The 1st argument, what is the difference between t, "fontset-default" and (frame-parameter nil 'font)? 

;; ### CJK
(dolist (script '(han ideographic-description cjk-misc kana bopomofo kanbun))
  (set-fontset-font t ; 
                    script
                    (font-spec :family "Microsoft YaHei"
                               :size 14)
                    nil nil))
;; han: 你好
;; ideographic-description:〚〛
;; cjk-misc: 〄
;; kana: ァア
;; bopomofo: ㄅ
;; kanbun: ㆝㆞㆟

;; ### Historic scripts, see

;; https://learn.microsoft.com/en-us/typography/font-list/segoe-ui-historic
;; https://en.wikipedia.org/wiki/Script_(Unicode)
;; (dolist (script '(aramaic brahmi carian cypriot-syllabary egyptian glagolitic gothic
;;                           old-italic kharoshthi lycian lydian meroitic ogham old-turkic
;;                           inscriptional-pahlavi phoenician inscriptional-parthian
;;                           runic
;;                           old-south-arabian shavian syriac ugaritic old-persian
;;                           cuneiform cuneiform-numbers-and-punctuation))
;;  (set-fontset-font t script (font-spec :family "Segoe UI Historic" :size 16) nil nil))

(set-fontset-font t 'aramaic (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐡀𐡁𐡂𐡃𐡄𐡅𐡆𐡇𐡈

(set-fontset-font t 'brahmi (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𑀡𑀢𑀣𑀤𑀥𑀠

(set-fontset-font t 'carian (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐋁𐋂𐋃𐋄𐋅𐋀

(set-fontset-font t 'cypriot-syllabary (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐠀𐠁𐠁𐠂𐠂𐠃𐠄𐠅

(set-fontset-font t 'egyptian (font-spec :family "Segoe UI Historic" :size 64) nil nil)
;; 𓀀𓀁𓀂𓀃 𓃒𓃓𓃔𓃕𓃖𓃗𓃘𓃙 𓄃𓄄 𓅀𓅁𓅂𓄿 

(set-fontset-font t 'glagolitic (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; ⰀⰁⰂⰃⰄ

(set-fontset-font t 'gothic (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐌰𐌱𐌲𐌳𐌴𐌵𐌶𐌷𐌸

(set-fontset-font t 'old-italic (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐌀𐌁𐌂𐌃

(set-fontset-font t 'kharoshthi (font-spec :family "Segoe UI Historic" :size 20) nil nil)
;; 𐨐𐨑𐨒𐨓

(set-fontset-font t 'lycian (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐊀𐊁𐊂𐊃𐊄

(set-fontset-font t 'lydian (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐤠𐤡𐤢𐤣𐤤𐤥𐤦

(set-fontset-font t 'meroitic (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐦠𐦡𐦢𐦣𐦤𐦥𐦦𐦧𐦨

(set-fontset-font t 'ogham (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;;  ᚁᚂᚃᚄᚅ

(set-fontset-font t 'old-turkic (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐰀𐰁𐰂𐰃𐰄𐰅

(set-fontset-font t 'inscriptional-pahlavi (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐭠𐭡𐭢𐭣𐭤𐭥

(set-fontset-font t 'phoenician (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐤀𐤁𐤂𐤃𐤄𐤅𐤆𐤇𐤈

(set-fontset-font t 'inscriptional-parthian (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐭀𐭁𐭂𐭃𐭄𐭅𐭆𐭇𐭈

(set-fontset-font t 'runic (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; ᛋᛗᚪᚢᚷ ᚹᚣᚱᛗ

(set-fontset-font t 'old-south-arabian (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐩡𐩢𐩣𐩤𐩥𐩠

(set-fontset-font t 'shavian (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; 𐑑𐑒𐑓𐑔𐑕𐑖𐑗𐑘𐑙

(set-fontset-font t 'syriac (font-spec :family "Segoe UI Historic" :size 16) nil nil)
;; ܐܑܒܓܔ

(set-fontset-font t 'ugaritic (font-spec :family "Segoe UI Historic" :size 20) nil nil)
;; 𐎀𐎁𐎂𐎃𐎄𐎅𐎆

(set-fontset-font t 'old-persian (font-spec :family "Segoe UI Historic" :size 20) nil nil)
;; 𐎠𐎡𐎢𐎣𐎤𐎥𐎦

(set-fontset-font t 'cuneiform (font-spec :family "Segoe UI Historic" :size 20) nil nil)
;; 𒀀𒀁𒀂𒀃𒀄𒀅𒀆

(set-fontset-font t 'cuneiform-numbers-and-punctuation (font-spec :family "Segoe UI Historic" :size 20) nil nil)
;; 𒐀𒐁𒐂𒐃𒐄𒐅𒐆𒐇𒐈

;; TODO: Try https://github.com/mickeynp/ligature.el
;; (when (version< "27.2" emacs-version)
;;   (require 'ligature))
;; ligature runic with magic spells
;; (set-fontset-font t 'runic (font-spec :family "BabelStone Moon Runes" :size 14) nil 'prepend)
;; SMAUG: ᛋᛗᚪᚢᚷ
;; WYRM: ᚹᚣᚱᛗ

;; ### symbol, e.g. Mathematical Operators block, etc
(set-fontset-font t 'symbol (font-spec :family
                                       "Segoe UI Symbol"
                                       ;; "Symbola"
                                       ;; "DejaVu Math Tex Gyre"
                                       :size 16)
                  nil nil)
;; Mathematical Operators in main font: ∑ √  ∩ ∫ ∆ (not be overidden)
;; Mathematical Operators not in main font: ∀ ∃ ∅ ∉∨
;; Miscellaneous Mathematical Symbols-A: ⟦⟧

;; ### mathematical, e.g. Mathematical Alphanumeric Symbols, etc
(set-fontset-font t 'mathematical (font-spec :family
                                             "Segoe UI Symbol"
                                             ;; "Symbola"
                                             ;; "DejaVu Math Tex Gyre"
                                             :size 16)
                  nil nil)
;; Mathematical Alphanumeric Symbols: 𝓐𝓑𝓒𝓓

;; ### mahjong-tile
(set-fontset-font t 'mahjong-tile (font-spec :family
                                             "Segoe UI Symbol"
                                             :size 32)
                  nil nil)
;; mahjong-tile: 🀀

;; ### domino-tile
(set-fontset-font t 'domino-tile (font-spec :family
                                      "Segoe UI Symbol"
                                      :size 32)
                  nil nil)
;; domino-tile: 🁀 🁁 🁂 🁃🁰🁱🁲🁳

;; ### playing-cards
(set-fontset-font t 'playing-cards (font-spec :family
                                      "Segoe UI Symbol"
                                      :size 64)
                  nil nil)
;; playing-cards: 🂠🂡🂢🂣🂤🂥🂦🂧🂨🂩🂪🂫🂬🂭🂮

;; ### chess-symbol
(set-fontset-font t 'chess-symbol (font-spec :family "Noto Sans Symbols 2" :size 20) nil nil)
;; chess-symbol: 🨀🨁🨂🨃🨄🨅🩠🩡🩢🩣🩤🩥🩦

;; ### Emojis symbol
(set-fontset-font t 'symbol (font-spec :family "Segoe UI Emoji" :size 20) nil 'prepend)
;; 🐙😀😁🤣

;; ### Emojis mahjong-tile
(set-fontset-font t 'mahjong-tile (font-spec :family "Segoe UI Emoji" :size 32) nil 'prepend)
;; mahjong-tile: 🀀

;; ### Unicode Fallback Fonts (speed up font search)

;; "Arial Unicode MS"
;; The font is from Office 2010 and it almost support full BMP (38917 characters)
;; https://web.archive.org/web/20121122124125/http://msdn.microsoft.com/en-us/goglobal/bb688134.aspx
;; https://learn.microsoft.com/en-us/typography/font-list/arial-unicode-ms
;; It is almost, because there are symbols are not in it, e.g. 'Miscellaneous Symbols and Arrow' and 'Miscellaneous Symbols and Pictographs'
(set-fontset-font t 'unicode-bmp (font-spec :family "Arial Unicode MS" :size 14) nil 'append) ; from

;; "Unicode BMP Fallback SIL"
(set-fontset-font t 'unicode-bmp (font-spec :family "Unicode BMP Fallback SIL" :size 24) nil 'append)

;; "Last Resort"
(dolist (script '(unicode unicode-smp unicode-sip unicode-ssp))
  (set-fontset-font t script (font-spec :family "Last Resort" :size 24) nil 'append))

(provide 'sc/font-settings)



