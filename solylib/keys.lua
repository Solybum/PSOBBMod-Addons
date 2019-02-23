-- Usage
-- Load solylib.keys
-- Use keys.keys in your combo box, store the result as is
-- When reading a key, use getKeyID(your_saved_combobox_result)
-- and compare it to the pressed key

-- Getting the pressed keys has to be done in your addon
-- I'll eventually add support for callbacks... probably

local keys = {}
local keyMapping = {}

keyMapping["NONE"]              =   0;

keyMapping["LBUTTON"]           =   1;
keyMapping["RBUTTON"]           =   2;
keyMapping["CANCEL"]            =   3;
keyMapping["MBUTTON"]           =   4;
keyMapping["XBUTTON1"]          =   5;
keyMapping["XBUTTON2"]          =   6;
-- Undefined 7
keyMapping["BACKSPACE"]         =   8;
keyMapping["TAB"]               =   9;
-- Reserved 10 ~ 11
keyMapping["CLEAR"]             =  12;
keyMapping["ENTER"]             =  13;
-- Undefined 14 ~ 15
keyMapping["SHIFT"]             =  16;
keyMapping["CONTROL"]           =  17;
keyMapping["ALT"]               =  18; -- Doesn't work?
keyMapping["PAUSE"]             =  19;
keyMapping["CAPS LOCK"]         =  20;
keyMapping["IME KANA"]          =  21;
-- Undefined 22
keyMapping["IME JUNJA"]         =  23;
keyMapping["IME FINAL"]         =  24;
keyMapping["IME KANJI"]         =  25;
-- Undefined 26
keyMapping["ESCAPE"]            =  27;
keyMapping["IME CONVERT"]       =  28;
keyMapping["IME NONCONVERT"]    =  29;
keyMapping["IME ACCEPT"]        =  30;
keyMapping["IME MODE CHANGE"]   =  31;
keyMapping["SPACEBAR"]          =  32;
keyMapping["PAGE UP"]           =  33;
keyMapping["PAGE DOWN"]         =  34;
keyMapping["END"]               =  35;
keyMapping["HOME"]              =  36;
keyMapping["LEFT ARROW"]        =  37;
keyMapping["UP ARROW"]          =  38;
keyMapping["RIGHT ARROW"]       =  39;
keyMapping["DOWN ARROW"]        =  40;
keyMapping["SELECT"]            =  41;
keyMapping["PRINT"]             =  42;
keyMapping["EXECUTE"]           =  43;
keyMapping["PRINT SCREEN"]      =  44;
keyMapping["INSERT"]            =  45;
keyMapping["DELETE"]            =  46;
keyMapping["HELP"]              =  47;
keyMapping["0"]                 =  48;
keyMapping["1"]                 =  49;
keyMapping["2"]                 =  50;
keyMapping["3"]                 =  51;
keyMapping["4"]                 =  52;
keyMapping["5"]                 =  53;
keyMapping["6"]                 =  54;
keyMapping["7"]                 =  55;
keyMapping["8"]                 =  56;
keyMapping["9"]                 =  57;
-- Undefined 58 ~ 64
keyMapping["A"]                 =  65;
keyMapping["B"]                 =  66;
keyMapping["C"]                 =  67;
keyMapping["D"]                 =  68;
keyMapping["E"]                 =  69;
keyMapping["F"]                 =  70;
keyMapping["G"]                 =  71;
keyMapping["H"]                 =  72;
keyMapping["I"]                 =  73;
keyMapping["J"]                 =  74;
keyMapping["K"]                 =  75;
keyMapping["L"]                 =  76;
keyMapping["M"]                 =  77;
keyMapping["N"]                 =  78;
keyMapping["O"]                 =  79;
keyMapping["P"]                 =  80;
keyMapping["Q"]                 =  81;
keyMapping["R"]                 =  82;
keyMapping["S"]                 =  83;
keyMapping["T"]                 =  84;
keyMapping["U"]                 =  85;
keyMapping["V"]                 =  86;
keyMapping["W"]                 =  87;
keyMapping["X"]                 =  88;
keyMapping["Y"]                 =  89;
keyMapping["Z"]                 =  90;
keyMapping["L WINDOWS"]         =  91;
keyMapping["R WINDOWS"]         =  92;
keyMapping["MENU"]              =  93;
-- Reserved 94
keyMapping["SLEEP"]             =  95;
keyMapping["NUMPAD 0"]          =  96;
keyMapping["NUMPAD 1"]          =  97;
keyMapping["NUMPAD 2"]          =  98;
keyMapping["NUMPAD 3"]          =  99;
keyMapping["NUMPAD 4"]          = 100;
keyMapping["NUMPAD 5"]          = 101;
keyMapping["NUMPAD 6"]          = 102;
keyMapping["NUMPAD 7"]          = 103;
keyMapping["NUMPAD 8"]          = 104;
keyMapping["NUMPAD 9"]          = 105;
keyMapping["MULTIPLY"]          = 106;
keyMapping["ADD"]               = 107;
keyMapping["SEPARATOR"]         = 108;
keyMapping["SUBTRACT"]          = 109;
keyMapping["DECIMAL"]           = 110;
keyMapping["DIVIDE"]            = 111;
keyMapping["F1"]                = 112;
keyMapping["F2"]                = 113;
keyMapping["F3"]                = 114;
keyMapping["F4"]                = 115;
keyMapping["F5"]                = 116;
keyMapping["F6"]                = 117;
keyMapping["F7"]                = 118;
keyMapping["F8"]                = 119;
keyMapping["F9"]                = 120;
keyMapping["F10"]               = 121;
keyMapping["F11"]               = 122;
keyMapping["F12"]               = 123;
keyMapping["F13"]               = 124;
keyMapping["F14"]               = 125;
keyMapping["F15"]               = 126;
keyMapping["F16"]               = 127;
keyMapping["F17"]               = 128;
keyMapping["F18"]               = 129;
keyMapping["F19"]               = 130;
keyMapping["F20"]               = 131;
keyMapping["F21"]               = 132;
keyMapping["F22"]               = 133;
keyMapping["F23"]               = 134;
keyMapping["F24"]               = 135;
-- Unassigned 136 ~ 143
keyMapping["NUM LOCK"]          = 144;
keyMapping["SCROLL LOCK"]       = 145;
-- OEM 146 ~ 150
-- Unassigned 151 ~ 159
keyMapping["L SHIFT"]           = 160;
keyMapping["R SHIFT"]           = 161;
keyMapping["L CONTROL"]         = 162;
keyMapping["R CONTROL"]         = 163;
keyMapping["L MENU"]            = 164;
keyMapping["R MENU"]            = 165;
keyMapping["BROWSER BACK"]      = 166;
keyMapping["BROWSER FORWARD"]   = 167;
keyMapping["BROWSER REFRESH"]   = 168;
keyMapping["BROWSER STOP"]      = 169;
keyMapping["BROWSER SEARCH"]    = 170;
keyMapping["BROWSER FAVORITES"] = 171;
keyMapping["BROWSER HOME"]      = 172;
keyMapping["VOLUME MUTE"]       = 173;
keyMapping["VOLUME DOWN"]       = 174;
keyMapping["VOLUME UP"]         = 175;
keyMapping["MEDIA NEXT"]        = 176;
keyMapping["MEDIA PREVIOUS"]    = 177;
keyMapping["MEDIA STOP"]        = 178;
keyMapping["MEDIA PLAY"]        = 179;
keyMapping["LAUNCH MAIL"]       = 180;
keyMapping["LAUNCH MEDIA"]      = 181;
keyMapping["LAUNCH APP1"]       = 182;
keyMapping["LAUNCH APP2"]       = 183;
-- Reserved 184 ~ 185
keyMapping[";"]                 = 186;
keyMapping["+"]                 = 187;
keyMapping[","]                 = 188;
keyMapping["-"]                 = 189;
keyMapping["."]                 = 190;
keyMapping["/"]                 = 191;
keyMapping["~"]                 = 192;
-- Reserved 193 ~ 215
-- Unassigned 216 ~ 218
keyMapping["["]                 = 219;
keyMapping["\\"]                = 220;
keyMapping["]"]                 = 221;
keyMapping["\'"]                = 222;
-- OEM 223
-- Reserved 224
-- OEM Specific 225
-- OEM_102 226
-- OEM Specific 227 ~ 228
-- PROCESSKEY 229
-- OEM Specific 230
-- PACKET 231
-- Unassigned 232
-- OEM Specific 233 ~ 245
-- ATTN 246
-- CRSEL 247
-- EXSEL 248
-- EREOF 249
-- PLAY 250
-- ZOOM 251
-- NONAME 252
-- PA1 253
-- OEM_CLEAR 254

keys = {
    "NONE",
    "LBUTTON",
    "RBUTTON",
    "CANCEL",
    "MBUTTON",
    "XBUTTON1",
    "XBUTTON2",
    "BACKSPACE",
    "TAB",
    "CLEAR",
    "ENTER",
    "SHIFT",
    "CONTROL",
    "ALT",
    "PAUSE",
    "CAPS LOCK",
    "IME KANA",
    "IME JUNJA",
    "IME FINAL",
    "IME KANJI",
    "ESCAPE",
    "IME CONVERT",
    "IME NONCONVERT",
    "IME ACCEPT",
    "IME MODE CHANGE",
    "SPACEBAR",
    "PAGE UP",
    "PAGE DOWN",
    "END",
    "HOME",
    "LEFT ARROW",
    "UP ARROW",
    "RIGHT ARROW",
    "DOWN ARROW",
    "SELECT",
    "PRINT",
    "EXECUTE",
    "PRINT SCREEN",
    "INSERT",
    "DELETE",
    "HELP",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "L WINDOWS",
    "R WINDOWS",
    "MENU",
    "SLEEP",
    "NUMPAD 0",
    "NUMPAD 1",
    "NUMPAD 2",
    "NUMPAD 3",
    "NUMPAD 4",
    "NUMPAD 5",
    "NUMPAD 6",
    "NUMPAD 7",
    "NUMPAD 8",
    "NUMPAD 9",
    "MULTIPLY",
    "ADD",
    "SEPARATOR",
    "SUBTRACT",
    "DECIMAL",
    "DIVIDE",
    "F1",
    "F2",
    "F3",
    "F4",
    "F5",
    "F6",
    "F7",
    "F8",
    "F9",
    "F10",
    "F11",
    "F12",
    "F13",
    "F14",
    "F15",
    "F16",
    "F17",
    "F18",
    "F19",
    "F20",
    "F21",
    "F22",
    "F23",
    "F24",
    "NUM LOCK",
    "SCROLL LOCK",
    "L SHIFT",
    "R SHIFT",
    "L CONTROL",
    "R CONTROL",
    "L MENU",
    "R MENU",
    "BROWSER BACK",
    "BROWSER FORWARD",
    "BROWSER REFRESH",
    "BROWSER STOP",
    "BROWSER SEARCH",
    "BROWSER FAVORITES",
    "BROWSER HOME",
    "VOLUME MUTE",
    "VOLUME DOWN",
    "VOLUME UP",
    "MEDIA NEXT",
    "MEDIA PREVIOUS",
    "MEDIA STOP",
    "MEDIA PLAY",
    "LAUNCH MAIL",
    "LAUNCH MEDIA",
    "LAUNCH APP1",
    "LAUNCH APP2",
    ";",
    "+",
    ",",
    "-",
    ".",
    "/",
    "~",
    "[",
    "\\",
    "]",
    "\'",
}

local function getKeyID(keyIndex)
    if keys[keyIndex] ~= nil then
        local keyName = keys[keyIndex]
        if keyMapping[keyName] ~= nil then
            return keyMapping[keyName];
        end
    end
    return -1;
end

return
{
    keys = keys,
    getKeyID = getKeyID,
}
