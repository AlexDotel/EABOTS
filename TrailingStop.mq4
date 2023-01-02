   //+------------------------------------------------------------------+
   //|                                                 TrailingStop.mq4 |
   //|                        Copyright 2022, MetaQuotes Software Corp. |
   //|                                             https://www.mql5.com |
   //+------------------------------------------------------------------+
   #property copyright "Copyright 2022, MetaQuotes Software Corp."
   #property link      "https://www.mql5.com"
   #property version   "1.00"
   #property strict
   
   double distanciaSL;
   int ticket;
      
   int OnInit()
     {
   //---
      
   //---
      return(INIT_SUCCEEDED);
     }
     
     
   void OnDeinit(const int reason)
     {
     }
     
   void OnTick()
     {
      if(OperacionesAbiertas() == 0){
         distanciaSL = (50*10)*MarketInfo(NULL, MODE_POINT); // 50 PIPS
         ticket = OrderSend(NULL,OP_BUY, 1.0, Ask, 1, Ask - distanciaSL, 0);
      }else{
         OrderSelect(ticket, SELECT_BY_TICKET);
         double nuevoSL = Ask - distanciaSL;
         
         if(nuevoSL>OrderStopLoss()){
            OrderModify(OrderTicket() , OrderOpenPrice(), nuevoSL, OrderTakeProfit(), 0 );
         }
      }
      
     }
   //+------------------------------------------------------------------+
   
   int OperacionesAbiertas(){
      int cantidadOrdenes = 0;
      for(int i = 0 ; i < OrdersTotal() ; i ++){
         OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         if(OrderSymbol() == Symbol()){
            cantidadOrdenes++;
            break;
         }
       }
       return cantidadOrdenes;
   }
   
   double distancia(double a, double b){
       return (a > b) ? (a - b) : (b - a);
   }