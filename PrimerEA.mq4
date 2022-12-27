

#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

   int magic = 1; //identificador para el robot que ingreso x orden
   input double lotaje = 0.1;
   input int SL = 3;
   input int TP = 9;

   int OnInit()
     {
      Print("Nuestro Robot se ha cargado");
      
      return(INIT_SUCCEEDED);
     }
     
   void OnDeinit(const int reason)
     {
      Print("Nuestro Robot se ha eliminado");
      
     }
     
   void OnTick()
     {
     
     if(OrdenesExistentes() == 0){
      if(Comprar() && FiltroHorario()){
         OrderSend(NULL, OP_SELL, lotaje, Ask, 1, Close[1] + (iATR(NULL, 0, 23, 1)*SL), Close[1] - (iATR(NULL, 0, 23, 1)*TP), "COMPRA ROBOT EJEMPLO 01", magic);
         Print("Hemos comprado");
      }   
     
     }else{
         //No hay ordenes abiertas
     }
    
      
      
     }
   
   bool Comprar(){
       if( High[1]>= iHigh(NULL, PERIOD_D1, 1) ){
         Print("VENDA PAPITO");
         return true;
      }else{
         Print("TODAVIA NO SE SUPERA EL MAXIMO");
         return false;
      }
   }
   
   bool FiltroHorario(){
      if(Hour() >= 8 && Hour() <= 12){
         return true;
      }else{
         return false;
      }
   }
   
   bool OrdenesExistentes(){
      int cantidadOrdenes = 0;
      for(int i = 0; i < OrdersTotal(); i++){
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
            if(OrderType() == OP_SELL && OrderMagicNumber() == magic){
               cantidadOrdenes++;
               break;
            }
         }
      
      }
      return cantidadOrdenes;      
   }
