public class SendSingleSMS {
    
    @InvocableMethod(label='Enviar SMS' description='Envia un mensaje SMS a un telefono')
    public static List<Results> sendSingle(List<Request> datosList) {
        Boolean respuesta = false;
        try{            
            SendSingleSMSService.SendSingleSMS(datosList.get(0).numeroSMS, datosList.get(0).mensajeSMS);
            respuesta = true;
        }catch(exception e){            
            system.debug('CATCH-INVOCABLE '+e.getMessage());
            respuesta = false;
        }
        Results response = new Results();
        response.ResultadoSMS = respuesta;
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;
    }

    public class Request{
        @Invocablevariable(label='Número' description='Número de telefono para enviar el SMS' required=true)
        public String numeroSMS;
        @Invocablevariable(label='Mensaje' description='Contenido del mensaje SMS' required=true)
        public String mensajeSMS;
    }
        
    public class Results {
        @InvocableVariable(label='Resultado SMS' description='Resultado SMS' required=true)
        public Boolean ResultadoSMS;
    }
}