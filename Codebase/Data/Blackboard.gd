#base class for storing data
#can load/save to/from json 
#and provides access functions
class_name blackboard

#the data stored in this blackboard
var data : Dictionary = {}

#for encryption/decrptiong
var key : String = "CoolBeanGames608"

#signals
signal NewDataAdded(key : String)
signal DataUpdated(key : String)
signal Saved
signal Loaded

#returns true if the data exists or not
func has(key : String) -> bool:
	return data.has(key)

#returns the data stored if it exists otherwise
#returns null
func get_data(key : String, default = null):
	return data.get(key , default)

#sets the data at the given key to the value listed
func set_data(key : String, value):
	if(has(key)):
		DataUpdated.emit(key)
	else:
		NewDataAdded.emit(key)
	data[key] = value

#region Operator Overloading
#for value = blackboard[key] functionality
func _get(property: StringName) -> Variant:
	return data.get(property,null)

#for blackboard[key] = value functionality
func _set(property: StringName, value: Variant) -> bool:
	if(has(property)):
		DataUpdated.emit(property)
	else:
		NewDataAdded.emit(property)
	data[property] = value
	return true

#for " 'key' in 'blackboard' functionality"
func _has(property: StringName) -> bool:
	return data.has(property)
#endregion

#region Saving and loading
#initialize this dictionary from a json file
func load_from_json(path : String):
	if(!path.to_lower().contains(".json")):
		push_error("path does not point to a valid json file, cannot open")
		return
	#load the file to text
	var raw_string : String
	var f = FileAccess.open(path,FileAccess.READ)
	if(f == null):
		push_error("failed to open json file (does it exist?)")
		return
	
	raw_string = f.get_as_text()
	
	#parse the file
	var json = JSON.new()
	var error = json.parse(raw_string)
	
	#set the data if valid
	if(error == OK):
		print("successfully loaded json data")
		if typeof(json.data) == TYPE_DICTIONARY:
			data = json.data
			Loaded.emit()
		else:
			push_error("Parsed JSON is not a dictionary")
	else:
		push_error("error encountered parsing json data: ", json.get_error_message())

#save this dictionary to a json file
func save_to_json(path : String):
	if(!path.to_lower().contains(".json")):
		push_error("path does not point to a valid json file, cannot open")
		return
	var json_string  = JSON.stringify(data)
	var f = FileAccess.open(path,FileAccess.WRITE)
	if(f == null):
		push_error("failed to open json file for writing")
		return
	f.store_string(json_string)
	Saved.emit()

##attempt to load an encrpypted json file
func load_from_encrypted_json(path : String):
	#load and decrpty the text
	var f = FileAccess.open(path,FileAccess.READ)
	if(f==null):
		push_error("Failed to load json file , exiting")
		return
	var raw_text = f.get_as_text()
	var decrypted = decrypt(raw_text)
	
	#parse the file
	var json = JSON.new()
	var error = json.parse(decrypted)
	
	#set the data if valid
	if(error == OK):
		print("successfully loaded json data")
		if typeof(json.data) == TYPE_DICTIONARY:
			data = json.data
			Loaded.emit()
		else:
			push_error("Parsed JSON is not a dictionary")
	else:
		push_error("error encountered parsing json data: ", json.get_error_message()) 

#attempt to SAVE an encrypted json file
func save_to_encrypted_json(path : String):
	if(!path.to_lower().contains(".json")):
		push_error("path does not point to a valid json file, cannot open")
		return
	var json_string  = JSON.stringify(data)
	var encrypted = encrypt(json_string)
	var f = FileAccess.open(path,FileAccess.WRITE)
	if(f == null):
		push_error("failed to open json file for writing")
		return
	f.store_string(encrypted)
	Saved.emit()
#endregion

#region Encryption
#take in a string and encrypt it (before saving)
func encrypt(target : String) -> String:
	var aes = AESContext.new()
	var iv = key.to_utf8_buffer().slice(0, 16)
	aes.start(AESContext.MODE_CBC_ENCRYPT,key.to_utf8_buffer(),iv)
	var encrypted = aes.update(target.to_utf8_buffer())
	aes.finish()
	return Marshalls.raw_to_base64(encrypted)

#read a encrptyed string out as plain data
func decrypt(target : String) -> String:
	var aes = AESContext.new()
	var iv = key.to_utf8_buffer().slice(0, 16)
	aes.start(AESContext.MODE_CBC_DECRYPT,key.to_utf8_buffer(),iv)
	var raw = Marshalls.base64_to_raw(target)
	var decrypted = aes.update(raw)
	aes.finish()
	return decrypted.get_string_from_utf8()
#endregion
