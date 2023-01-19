   
   
   #property copyright "Copyright 2023, MetaQuotes Software Corp."
   #property link      "https://www.mql5.com"
   #property version   "1.00"
   #property strict
  
   int ticket;
   double stopLoss = 10.0;
   double takeProfit = 1000.0;
   
   int OnInit()
     {
   
      return(INIT_SUCCEEDED);
     }
   
   void OnDeinit(const int reason)
     {
      
     }
   
   void OnTick()
     {
   
      if(OrdersTotal() >= 1){
         Comment("Hay Ordenes Abiertas");
         setBreakEven();
      }else{
         ticket = OrderSend(Symbol(), OP_BUY, 1.0, Ask, 3, Bid - stopLoss * Point, Ask + takeProfit * Point);
         if(ticket < 0)
             Comment("Error al colocar orden");
         else
             Comment("Orden colocada exitosamente. Ticket: ", ticket);
      }
      
     }
   
         void setBreakEven() {
          for (int i = 0; i < OrdersTotal(); i++) {
              if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
                  int distance = (OrderOpenPrice() - stopLoss) * Point ;
                  if (OrderType() == OP_BUY && Bid >= OrderOpenPrice() + distance) {
                      double breakEvenPrice = OrderOpenPrice() + (OrderStopLoss() * Point);
                      OrderModify(OrderTicket(), OrderOpenPrice(), breakEvenPrice, OrderTakeProfit(), 0, Blue);
                  } else if (OrderType() == OP_SELL && OrderStopLoss() == 0) {
                      double breakEvenPrice = OrderOpenPrice() - (OrderStopLoss() * Point);
                      OrderModify(OrderTicket(), OrderOpenPrice(), breakEvenPrice, OrderTakeProfit(), 0, Blue);
                  }
              }
          }
      }

