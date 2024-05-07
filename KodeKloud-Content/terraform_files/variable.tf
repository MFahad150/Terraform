variable "filename" {
  default = "/home/fahad/pets.txt"
  type = string
  description = "This is the path of the directory"
}

# variable "content" {
#   default = "I love my ${random_pet.my_pet.id} pet"  
#   type = string
#   description = "Content in the file"
# }

variable "filepermission" {
  default = 0700
  type = number
  description = "File level ACL"
}

variable "prefix" {
  default = "Mr"
  type = string
  description = "Prefix define the starting words"
}

variable "separator" {
  default = "."
  type = string
  description = "separate the two words"
}

variable "length" {
  default = 1
  type = number
  description = "Length of the random word"
}




########################  list variable

variable "my_list" {
  default = ["Mr", "Mrs", "Sr"]
  type = list
  description = "list of the elements"
}                                           # var.my_list[1]


variable "list_string" {
  default = ["Mr", "Mrs", "Sr"]
  type = list(string)
  description = "list of the elements that contains string"
}                                           # var.list_string[0]

variable "list_number" {
  default = [1, 2, 3]
  type = list(number)
  description = "list of the elements that contains numbers"
}                                           # var.list_number[0]


########################  set variable -- Set does not contain duplicates as list accept duplicates

# variable "my_set" {
#   default = ["Mr", "Mrs", "Mr"]   ## This is not allow
#   type = set
#   description = "set of the elements"
# }                                           # var.my_set[1] 




############################ tuple Variable -- it is similar to list and contains sequence of elements. difference is that it have different variable types in the tuple

variable kitty_tuple {
  type        = tuple([string, number, bool])
  default     = ["cats", 7, true]
  description = "Tuple have different type in the tuple"
}


############################## map variable

variable "my_map" {
  default = {
    "statement1" = "ABC"
    "statement2" = "XYZ"
  }
  type = map
  description = "map of the elements"
}                                           # var.my_map["statement1"]


variable "cats" {
  default = {
    "color" = "Brown"
    "name" = "Bella"
  }
  type = map(string)
  description = "map of the elements that contains cats name and color"
}                                           # var.cat["color"]


variable "pets_count" {
  default = {
    "dogs" = 3
    "Cats" = 1
    "GoldFish" = 5
  }
  type = map(number)
  description = "map of the elements that contains number of pets"
}                                           # var.pets_count["GoldFish"]





####################### Object variable

variable "cat_object"{
    default = {
        name = "bella"
        color = "Brown"
        age = 7
        food = ["fish", "Chicken", "Turkey"]
        favourite_pet = true
    }
    type = object({
        name = string
        color = string
        age = number
        food = list(string)
        favourite_pet = bool
    })
    description = ""
}



################## Variable for Meta Arguments


variable MetaArgu {
  type        = string
  default     = "/home/fahad/metaArgu1"
  description = "description"
}

variable MetaArgu2 {
  type        = list(string)
  default     = [
    "/home/fahad/metaArgu1",
    "/home/fahad/metaArgu2",
    "/home/fahad/metaArgu3"
  ]
  description = "description"
}


variable foreachvar {
  type        = set(string)
  default     = [
    "/home/fahad/varforeach1",
    "/home/fahad/varforeach2",
    "/home/fahad/varforeach3"
  ]
  description = "description"
}

variable foreachvar2 {
  type        = list(string)
  default     = [
    "/home/fahad/varforeach1",
    "/home/fahad/varforeach2",
    "/home/fahad/varforeach3"
  ]
  description = "description"
}

