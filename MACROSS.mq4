      //+------------------------------------------------------------------+
      //|                                                      MACROSS.mq4 |
      //|                        Copyright 2022, MetaQuotes Software Corp. |
      //|                                             https://www.mql5.com |
      //+------------------------------------------------------------------+
      #property copyright "Copyright 2022, MetaQuotes Software Corp."
      #property link      "https://www.mql5.com"
      #property version   "1.00"
      #property strict

      int rsi_period = 14;  // Período del RSI
      input ENUM_TIMEFRAMES timeframeRSI = PERIOD_H1;
      
      input int operacionesMaximas = 2;
     
      int magic = 1;
      
      input int ma1 = 9;  // Media móvil 1
      input int ma2 = 12;  // Media móvil 2
     
      double ma1_value;
      double ma2_value;
      
      double ma1_prev;
      double ma2_prev;
      
      input double lots = 0.1;  // Tamaño de la posición
      input double sl = 3;  // Pérdida máxima permitida
      input double tp = 9;  // Ganancia máxima esperada

      void OnTick(){
      
         double rsi_value = iRSI(NULL, timeframeRSI, rsi_period, PRICE_CLOSE, 0);  // Valor del RSI

         double ma1_value = iMA(NULL, 0, ma1, 0, MODE_SMA, PRICE_CLOSE, 0);
         double ma2_value = iMA(NULL, 0, ma2, 0, MODE_SMA, PRICE_CLOSE, 0);

         double ma1_prev = iMA(NULL, 0, ma1, 0, MODE_SMA, PRICE_CLOSE, 1);
         double ma2_prev = iMA(NULL, 0, ma2, 0, MODE_SMA, PRICE_CLOSE, 1);
         
         if (OrdersTotal() < operacionesMaximas){
            
            if (ma1_value > ma2_value && ma1_prev < ma2_prev)
            {
               if(FiltroRSI(rsi_value) == "compra"){
                  double atrSL = Close[1] - (iATR(NULL, 0, 23, 1)*sl);
                  double atrTP = Close[1] + (iATR(NULL, 0, 23, 1)*tp);
                  OrderSend(NULL, OP_BUY, lots, Ask, 1, atrSL, atrTP, NULL, "Comprando", magic, clrSteelBlue);
               
               }
               
            }
            else if (ma1_value < ma2_value && ma1_prev > ma2_prev)
            {
               if(FiltroRSI(rsi_value) == "venta"){
                  double atrSL = Close[1] + (iATR(NULL, 0, 23, 1)*sl);
                  double atrTP = Close[1] - (iATR(NULL, 0, 23, 1)*tp);
                  OrderSend(NULL, OP_SELL, lots, Bid, 1, atrSL, atrTP, NULL, "Comprando", magic, clrSteelBlue);
               
               }
               
            }
            
            }
            
      }
      
      void CalcularMedias(){
      
         double ma1_value = iMA(NULL, 0, ma1, 0, MODE_SMA, PRICE_CLOSE, 0);
         double ma2_value = iMA(NULL, 0, ma2, 0, MODE_SMA, PRICE_CLOSE, 0);
         
         double ma1_prev = iMA(NULL, 0, ma1, 0, MODE_SMA, PRICE_CLOSE, 1);
         double ma2_prev = iMA(NULL, 0, ma2, 0, MODE_SMA, PRICE_CLOSE, 1);
      
      }
      
      void CompararMedias(){
           if (ma1_value > ma2_value && ma1_prev < ma2_prev)
            {
              Comprar();
            }
            else if (ma1_value < ma2_value && ma1_prev > ma2_prev)
            {
              Vender();
            }

         }
         
      void Comprar(){
         double atrSL = Close[1] - (iATR(NULL, 0, 23, 1)*sl);
         double atrTP = Close[1] + (iATR(NULL, 0, 23, 1)*tp);
         OrderSend(NULL, OP_BUY, lots, Ask, 1, atrSL, atrTP, NULL, "Comprando", magic, clrSteelBlue);

      }
         
      void Vender(){
         double atrSL = Close[1] + (iATR(NULL, 0, 23, 1)*sl);
         double atrTP = Close[1] - (iATR(NULL, 0, 23, 1)*tp);
         OrderSend(NULL, OP_SELL, lots, Bid, 1, atrSL, atrTP, NULL, "Comprando", magic, clrSteelBlue);

      }
      
      int OrdenesExistentes(){
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
      
      string FiltroRSI(double rsi_value){
         if (rsi_value > 70)
         {
           return "compra";
         }
         else
         {
           return "venta";
         }
         
      }