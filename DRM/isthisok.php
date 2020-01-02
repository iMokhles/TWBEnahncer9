

<?php

function urlsafe_b64encode($string)
{
    $data = base64_encode($string);
    $data = str_replace(array('+','/','='),array('-','_',''),$data);
    return $data;
}

function validate_uuid($uuid, $packageID)
{
	$udid = $_SERVER["HTTP_X_UNIQUE_ID"];
	if (!$udid) {
		echo "403 You Are Not An iPhone";
		return;
	}
	echo $udid;

	$request = array();
	$request['device']=$uuid;
	$request['host']=$_SERVER['REMOTE_ADDR']; // don't send this unless you're a phone
	$request['mode']="local";
	$request['nonce']=time();
	$request['product']= $packageID; //"com.imokhles.waenhancer";
	$request['timestamp']=time();
	$request['vendor']="imokhles";

	$secretkey = "OPS_OLD"; // get this from saurik

	ksort($request);
	$request_presign = http_build_query($request);

	$request['signature'] = urlsafe_b64encode(hash_hmac('sha1', $request_presign, $secretkey, true));

	$http_request = http_build_query($request);
	$request_url = "http://cydia.saurik.com/api/check?".$http_request;

	$fd = fopen($request_url,"r");
	$response_raw = "";
	if($fd)
	{
		while(!feof($fd))
		{
			$response_raw .= fgets($fd, 16384);
		}
		fclose($fd);
	}

	// If state=completed exists, we are authorized. Anything else and we are not.
	if($response_raw)
	{
		parse_str($response_raw, $response);
		$return_sig = $response['signature'];
		unset($response['signature']);

		ksort($response);

		$serialized_response = http_build_query($response);

		$return_chk = urlsafe_b64encode(hash_hmac('sha1', $serialized_response, $secretkey, true));

		if($response['state']=="completed" && $return_chk == $return_sig)
		{
			if(array_key_exists('payment', $response))
			{
				return $response['payment'];
				echo "Test Payment DONE";
			}
			else
			{
				return 1337;
				echo "Test Payment DONE";
			}
		}
	}
	return 'Cracked';
}
	if (isset($_GET['udid'])) {
	$valid = validate_uuid($_GET['udid'], $_GET['packageid']);
	// echo $_GET['udid'];
	echo $valid;
}
?>
