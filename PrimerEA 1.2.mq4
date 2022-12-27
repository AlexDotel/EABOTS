

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
     
     if(OrdenesExistentes() <= 0){
      if(Vender() && FiltroHorario() && FiltroTendencia()){
         OrderSend(NULL, OP_SELL, lotaje, Bid, 1, Close[1] + (iATR(NULL, 0, 23, 1)*SL), Close[1] - (iATR(NULL, 0, 23, 1)*TP), "COMPRA ROBOT EJEMPLO 01", magic);
         Print("Hemos VENDIDO");
      }   
     
     }else{
         //Hay ordenes abiertas
         if(Hour() >= 12){
            CerrarOrdenes();
         }
     }
    
      
      
     }
   
   bool Vender(){
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
         Print("HORARIO BUENO PAPITO");
         return true;
      }else{
         return false;
      }
   }
   
   bool FiltroTendencia(){
      int ema200 = iMA(NULL,PERIOD_H4,200, 0, MODE_EMA, PRICE_CLOSE, 1 );
      if(PRICE_CLOSE< ema200){
         Print("BAJISTA");
         return true;
      }else{
         return false;
      }
   }
   
   bool OrdenesExistentes(){
      int cantidadOrdenes = 0;
      for(int i = 0; i < OrdersTotal(); i++){
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
            if(OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber() == magic){
               cantidadOrdenes++;
               break;
            }
         }
      
      }
      return cantidadOrdenes;      
   }
   
   void CerrarOrdenes(){
      for(int i; i<OrdersTotal(); i++){
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
               if(OrderType() == OP_SELL){
                  OrderClose(OrderTicket(), OrderLots(), Ask, 1);
               }else if(OrderType() == OP_BUY){
                  OrderClose(OrderTicket(), OrderLots(), Bid, 1);
               }
            }
         }
      }
   }
