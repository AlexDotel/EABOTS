//+------------------------------------------------------------------+
//|                                              TrailingStopATR.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
     
   input double lotaje = 0.1;
   input int SL = 3;
   input int TP = 9;
   int ticket;
   double distanciaBE;
   double precioBE;
   
  
   void OnTick(){
      if(OperacionesAbiertas() == 0){
         
         double atrSL = Close[1] + (iATR(NULL, 0, 23, 1)*SL);
         double atrTP = Close[1] - (iATR(NULL, 0, 23, 1)*TP);
         
         ticket = OrderSend(NULL, OP_SELL, lotaje, Bid, 1, atrSL, atrTP,0);
         Alert("Hemos VENDIDO");  
         
      }
      
      else{
      
         OrderSelect(ticket, SELECT_BY_TICKET);
         distanciaBE = (OrderStopLoss() - OrderOpenPrice()*10)*MarketInfo(NULL, MODE_POINT);

         // Calculamos el precio de breakeven
         precioBE = (OrderType() == ORDER_TYPE_BUY) ? (OrderOpenPrice() + distanciaBE) : (OrderOpenPrice() - distanciaBE * Point);
         
         //Modificamos la orden
         OrderModify(ticket, OrderOpenPrice(), precioBE, OrderTakeProfit(), 0, Green);
          
      }
      
   }
   
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
