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

#region data access
#returns true if the data exists or not
func has(_key : String) -> bool:
	return data.has(_key)

#returns the data stored if it exists otherwise
#returns null
func get_data(_key : String, default = null):
	return data.get(_key , default)

#sets the data at the given key to the value listed
func set_data(_key : String, value):
	if(has(_key)):
		DataUpdated.emit(_key)
	else:
		NewDataAdded.emit(_key)
	data.set(_key,value)
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
func save_to_encrypted_json(path: String):
	if !path.to_lower().ends_with(".json"):
		push_error("path does not point to a valid json file, cannot open")
		return
	
	var dir_path = path.get_base_dir()
	
	# Create a DirAccess instance for the target directory
	var dir := DirAccess.open(dir_path)
	if dir == null:
		# If the directory doesn't exist, try to create it
		var dir_error = DirAccess.make_dir_recursive_absolute(dir_path)
		if dir_error != OK:
			push_error("Failed to create directory '%s', error: %s" % [dir_path, error_string(dir_error)])
			return
	
	var json_string = JSON.stringify(data)
	var encrypted = encrypt(json_string)
	
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("failed to open json file for writing, error: %s" % error_string(FileAccess.get_open_error()))
		return
	
	f.store_string(encrypted)
	Saved.emit()
#endregion

#region Encryption
#take in a string and encrypt it (before saving)
# In your Blackboard script
# ...

func encrypt(encrypt_target: String) -> String:
	var aes = AESContext.new()
	var iv = key.to_utf8_buffer().slice(0, 16)
	
	# Convert string to a byte array and get its length
	var target_bytes = encrypt_target.to_utf8_buffer()
	var target_length = target_bytes.size()
	
	# Calculate padding needed
	var padding_size = 16 - (target_length % 16)
	
	# Create the padded byte array
	var padded_bytes = target_bytes
	padded_bytes.resize(target_length + padding_size)
	
	# Fill the padding with the padding size value
	for i in range(padding_size):
		padded_bytes[target_length + i] = padding_size
		
	aes.start(AESContext.MODE_CBC_ENCRYPT, key.to_utf8_buffer(), iv)
	var encrypted = aes.update(padded_bytes)
	aes.finish()
	
	return Marshalls.raw_to_base64(encrypted)

func decrypt(decrypt_target: String) -> String:
	var aes = AESContext.new()
	var iv = key.to_utf8_buffer().slice(0, 16)
	var raw = Marshalls.base64_to_raw(decrypt_target)
	
	aes.start(AESContext.MODE_CBC_DECRYPT, key.to_utf8_buffer(), iv)
	var decrypted_bytes = aes.update(raw)
	aes.finish()

	# Get the last byte to find the padding size
	var padding_size = decrypted_bytes[decrypted_bytes.size() - 1]
	
	# Remove padding from the byte array
	var unpadded_bytes = decrypted_bytes.slice(0, decrypted_bytes.size() - padding_size)

	return unpadded_bytes.get_string_from_utf8()

#endregion
