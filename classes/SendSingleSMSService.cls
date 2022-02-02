global inherited sharing class SendSingleSMSService {

    final static String APIKEY = System.label.SMS_Api_Key;
    final static String SECRET = System.label.SMS_Secret_key;
    final static String URLAPISINGLE = System.label.SMS_Url_Api_Single;

    @future(callout=true)
    global static void SendSingleSMS(String numero, String mensaje){
        String response = '';
        try{            
            String data = sendSingleJson(numero, mensaje);
            Blob  mac = Blob.ValueOf(SECRET);
            String text = 'POST' + '|' + URLAPISINGLE + '|' + data;
            String pwd = EncodingUtil.convertToHex(Crypto.generateMac('hmacSHA1',Blob.ValueOf(text),mac));
            String pwds = APIKEY + ':' + pwd;
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(URLAPISINGLE);
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setHeader('Authorization', 'Hmac ' + EncodingUtil.base64Encode(Blob.ValueOf(pwds)));
            req.setHeader('Content-Length',String.valueOf(data.length()));
            req.setBody(data);
            Http binding = new Http();
            HttpResponse res = binding.send(req);
            response =  res.getBody();
			system.debug('RESPONSE '+response);
        }catch(exception e){
            system.debug('CATCH-SERVICE '+e.getMessage());
        }
    }


    public static String sendSingleJson(String numero, String mensaje) {
        //En esta api solo se pueden hacer envios UNO a UNO
        String result = '';
        //Colecciones individuales que son para el destinatario
        Map<String, Object> sms = new Map<String, Object>();
        sms.put('phone', numero);
        sms.put('message', mensaje);
        sms.put('indicative', '57');
        //Colección principal que contiene la información básica del envío para         api encrypted
        Map<String, Object> send = new Map<String, Object>();
        send.put('name', 'Envio desde Java Single');
        /*
        Si notification es false, el siguiente parametro email se deja como
        cadena vacia;
        si notification es true, el parametro email contiene 1 o mas correos
        electronicos (hasta 5)
        separados por coma y sin espacios donde llega notificacion de
        constancia de cuantos envios fueron realizados.
        */
        send.put('notification', false);
        send.put('email', '');
        send.put('receiver', sms);
        //Id de categoria de sms, se puede encontrar en la plataforma AIO
        send.put('idSmsCategory', '43');
        send.put('datesend', '');
        /*Si datenow es true, el parametro anterior dateSend deja como cadena
        vacia
        de lo contrario dateSend se coloca fecha y hora con el siguiente formato
        2018-09-21 00:00:00
        */
        send.put('datenow', true);
        send.put('timezone', '-0500');
        //PARAMETROS OPCIONALES
        /*
        1. morecaracter: Este permite envios por más de 160 caracteres hasta
        300 caracteres,
        si se desea hacer uso de este se manda con valor TRUE.
        send.put('morecaracter', true);
        */
        result = JSON.serialize(send);
        
        system.debug('payload ' + result);
        return result;
        }
}