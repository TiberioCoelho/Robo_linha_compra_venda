//+------------------------------------------------------------------+
//|                                                        Hedge.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <ChartObjects\ChartObjectsLines.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>

CSymbolInfo simbolo;

bool cap=true;
double compra;
double venda;
int c;
int v;
double lot=0.01;
bool op_compra=true;
bool op_venda=true;
double objetivo_c;
bool config_c=false;
double objetivo_v;
bool config_v=false;
//#define MAGIC 1234501
bool   ExtHedging=true;

input double nivel_canal=40; // nivél do canal(suporte e resistencia)
double alavancagem=2;
double preco_compra=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
double preco_venda=SymbolInfoDouble(_Symbol,SYMBOL_BID);

CTrade operacao;
CChartObjectHLine linhahorizontal;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

    linhahorizontal.Create(0,"linhacompra",0,preco_compra);
    linhahorizontal.Create(0,"linhavenda",0,preco_venda);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   Comment("Compra: ",compra,"  Venda: ",venda);
   if(cap==true)
     {
      compra=SymbolInfoDouble(_Symbol,SYMBOL_BID)+nivel_canal*_Point;
      venda=SymbolInfoDouble(_Symbol,SYMBOL_BID)-nivel_canal*_Point;
      cap=false;
     }
   if(SymbolInfoDouble(_Symbol,SYMBOL_BID)>compra && op_compra==true)
     {
      op_venda=true;
      
      
      operacao.Buy(lot,_Symbol,preco_compra,venda,0,"");
      lot=lot*alavancagem;

      
      op_compra=false;
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SymbolInfoDouble(_Symbol,SYMBOL_BID)<venda && op_venda==true)
     {
      op_compra=true;  
      operacao.Sell(lot,_Symbol,preco_venda,compra,0,"");
      lot=lot*alavancagem;
     
      op_venda=false;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


  }
//+------------------------------------------------------------------+