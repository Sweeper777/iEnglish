import Foundation

class Translator {
    private let dictionary = ReversibleDictionary<String, String>(dict: [
        "america" : "美國",
        "pentane" : "戊烷",
        "triglyceride" : "甘油三酯",
        "statistics" : "統計",
        "polynomial" : "多項式",
        "ethanol" : "乙醇"
    ])
    
    func translate (text: String) -> String? {
        return dictionary.getFromKey1(text.lowercaseString) ?? dictionary.getFromKey2(text.lowercaseString)
    }
}

struct ReversibleDictionary<Key1: Hashable, Key2: Hashable> {
    private var dict1 = Dictionary<Key1, Key2>()
    private var dict2 = Dictionary<Key2, Key1>()
    
    mutating func add(key1 key1: Key1, key2: Key2) -> Bool {
        if dict1[key1] != nil || dict2[key2] != nil {
            return false
        }
        
        dict1[key1] = key2
        dict2[key2] = key1
        return true
    }
    
    func getFromKey1(key1: Key1) -> Key2? {
        return dict1[key1]
    }
    
    func getFromKey2(key2: Key2) -> Key1? {
        return dict2[key2]
    }
    
    init() {
        
    }
    
    init(dict: Dictionary<Key1, Key2>) {
        for item in dict {
            add(key1: item.0, key2: item.1)
        }
    }
}