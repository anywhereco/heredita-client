extends Node

## Should include the http at the start, so e.g. "https://verycoolservice.infernity.dev"
## Should not include the trailing slash.
var http_server = ""

## The token that thee HTTP service should use.
var http_token = ""

enum HTTPResult {
	SUCCESSFUL,
	UNREACHABLE,
	FAILED_REQUEST,
	BAD_RESPONSE
}

func request(endpoint,method,auth=null,query_params={},response_body_required=true) -> Result:
	var req = HTTPRequest.new()
	add_child(req)
	req.request_completed.connect(req.queue_free.unbind(4))
	
	#var request_url = http_server+"/"+endpoint
	var request_url = endpoint
	var first_param = true
	for key in query_params:
		request_url += (("?" if first_param else "&") +
						str(key).uri_encode() + "=" + str(query_params[key]).uri_encode())
		first_param = false
	
	var error = OK
	if auth:
		error = req.request(request_url, ["Authorization: Bearer %s" % http_token], method)
	else:
		error = req.request(request_url, [], method)
		
	if error != OK:
		return Result.err(HTTPResult.UNREACHABLE)
	
	var request_outcome = await req.request_completed
	
	var result = request_outcome[0]
	var _response_code = request_outcome[1]
	var _headers = request_outcome[2]
	var body = request_outcome[3]

	if result != HTTPRequest.RESULT_SUCCESS:
		return Result.err(HTTPResult.FAILED_REQUEST)
		
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	if response == null and response_body_required:
		return Result.err(HTTPResult.BAD_RESPONSE)
	
	return Result.ok(response)
