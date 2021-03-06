
/*
    Generated by the Return of the Table compiler.
 */


import rtlib.*;
import java.util.Scanner;

class customerStats_anonymous_functor_1 implements JoinPredicate {


customerStats_anonymous_functor_1(){}
public boolean test(Record record, Record a, Record b) {
                return ((((a).entries[0]._Integer)==((b).entries[0]._Integer)));
            }}
class customerStats_anonymous_functor_2 implements JoinPredicate {


customerStats_anonymous_functor_2(){}
public boolean test(Record record, Record a, Record b) {
                return ((((a).entries[6]._Integer)==((b).entries[0]._Integer)));
            }}
class customerStats_anonymous_functor_3 implements FilterPredicate {
Record rt14;

customerStats_anonymous_functor_3(Record _rt14){rt14 = _rt14;}
public boolean test(Record record) {
                return ((((record).entries[1]._String).equals(((rt14).entries[1]._String))));
            }}
class customerStats_anonymous_functor_4 implements FilterPredicate {
Record rt19;

customerStats_anonymous_functor_4(Record _rt19){rt19 = _rt19;}
public boolean test(Record record) {
                return ((((record).entries[7]._Integer)==((rt19).entries[0]._Integer)));
            }}
class customerStats_anonymous_functor_5 implements FilterPredicate {
Record rt22;

customerStats_anonymous_functor_5(Record _rt22){rt22 = _rt22;}
public boolean test(Record record) {
                return ((((record).entries[6]._Integer)==((rt22).entries[0]._Integer)));
            }}


public class customerStats {
    static UserDefinedType rt0;
static UserDefinedType rt1;
static UserDefinedType rt2;
static UserDefinedType rt3;
static UserDefinedType rt4;
static Table rt5;
static Table rt6;
static Table rt7;
static Table rt8;
static Table rt9;
static Table rt10;
static Table rt11;
public static boolean rt13(Record rt14) {
{
for (Record rt15 : (rt11)){{
 if (((rt15).entries[0]._Integer)==((rt14).entries[0]._Integer)) {{
 return (false);

}} else {{

}}

}}
 return (true);

}}

public static double rt12(Table rt14) {
{
double rt15;
(rt15)=(0.);
 if (((rt14).mySize())==(0)) {{
 return (rt15);

}} else {{

}}
for (Record rt16 : (rt14)){{
(rt15)+=((rt16).entries[10]._Float);

}}
 return (rt15);

}}

    private static Scanner input;
		static String globArgs[];
    
	public static void main(String args[]) {
        input = new Scanner(System.in);
				globArgs = new String[args.length];
				for(int globArgCounter = 0; globArgCounter < args.length; globArgCounter++)
					globArgs[globArgCounter] = args[globArgCounter];
				
        customerStats.rt0 = new UserDefinedType("Customer");
customerStats.rt0.add("Customer's Id", Data.INT_TYPE);
customerStats.rt0.add("Customer's name", Data.STRING_TYPE);
customerStats.rt0.add("Customer's city", Data.STRING_TYPE);
customerStats.rt0.add("Customer's state", Data.STRING_TYPE);
customerStats.rt0.add("Customer's age", Data.INT_TYPE);

customerStats.rt1 = new UserDefinedType("Item");
customerStats.rt1.add("Item's Id", Data.INT_TYPE);
customerStats.rt1.add("Item's name", Data.STRING_TYPE);
customerStats.rt1.add("Item's cost", Data.FLOAT_TYPE);

customerStats.rt2 = new UserDefinedType("Store");
customerStats.rt2.add("Store's Id", Data.INT_TYPE);
customerStats.rt2.add("Store's name", Data.STRING_TYPE);

customerStats.rt3 = new UserDefinedType("Purchase");
customerStats.rt3.add("Purchase's custId", Data.INT_TYPE);
customerStats.rt3.add("Purchase's prodId", Data.INT_TYPE);
customerStats.rt3.add("Purchase's locId", Data.INT_TYPE);

customerStats.rt4 = new UserDefinedType("Report");
customerStats.rt4.add("Report's Id", Data.INT_TYPE);
customerStats.rt4.add("Report's name", Data.STRING_TYPE);
customerStats.rt4.add("Report's totalPurchased", Data.FLOAT_TYPE);
customerStats.rt4.add("Report's favStore", Data.STRING_TYPE);
customerStats.rt4.add("Report's percAtFavStore", Data.FLOAT_TYPE);
customerStats.rt4.add("Report's favItem", Data.STRING_TYPE);
customerStats.rt4.add("Report's percOnFavItem", Data.FLOAT_TYPE);

{
(rt5)=(CsvInterpreter.toTable(WorkingDir.getPath(("custs.csv")), customerStats.rt0));
(rt6)=(CsvInterpreter.toTable(WorkingDir.getPath(("purchases.csv")), customerStats.rt3));
(rt7)=(CsvInterpreter.toTable(WorkingDir.getPath(("items.csv")), customerStats.rt1));
(rt8)=(CsvInterpreter.toTable(WorkingDir.getPath(("stores.csv")), customerStats.rt2));
(rt9)=(((rt5).join((rt6), new customerStats_anonymous_functor_1())).join((rt7), new customerStats_anonymous_functor_2()));
(rt10)=(new Table(customerStats.rt4));
for (Record rt14 : (rt9)){{
Table rt15;
(rt15)=((rt9).filter(new customerStats_anonymous_functor_3(rt14)));
double rt16;
(rt16)=(customerStats.rt12((rt15)));
String rt17;
(rt17)=("");
double rt18;
(rt18)=(0.);
for (Record rt19 : (rt8)){{
double rt20;
(rt20)=(customerStats.rt12(((rt15).filter(new customerStats_anonymous_functor_4(rt19)))));
 if ((rt20)>(rt18)) {{
(rt17)=((rt19).entries[1]._String);
(rt18)=(rt20);

}} else {{

}}

}}
double rt19;
(rt19)=((rt18)/(rt16));
String rt20;
(rt20)=("");
double rt21;
(rt21)=(0.);
for (Record rt22 : (rt7)){{
double rt23;
(rt23)=(customerStats.rt12(((rt15).filter(new customerStats_anonymous_functor_5(rt22)))));
 if ((rt23)>(rt21)) {{
(rt20)=((rt22).entries[1]._String);
(rt21)=(rt23);

}} else {{

}}

}}
double rt22;
(rt22)=((rt21)/(rt16));
(rt10).addRow((new Record(customerStats.rt4, new Data(((rt14).entries[0]._Integer)), new Data(((rt14).entries[1]._String)), new Data((rt16)), new Data((rt17)), new Data((rt19)), new Data((rt20)), new Data((rt22)))));

}}
(rt11)=(new Table(customerStats.rt4));
for (Record rt14 : (rt10)){{
Record rt15;
(rt15)=(rt14);
for (Record rt16 : (rt10)){{
 if ((((rt16).entries[2]._Float)>((rt15).entries[2]._Float))&&(customerStats.rt13((rt16)))) {{
(rt15)=(rt16);

}} else {{

}}

}}
 if (customerStats.rt13((rt15))) {{
(rt11).addRow((rt15));

}} else {{

}}
(rt10).delete((rt15));

}}
System.out.println((rt11));
CsvInterpreter.toFile(WorkingDir.getPath(("CustomerReport.csv")), (rt11));

}
    }    
}

