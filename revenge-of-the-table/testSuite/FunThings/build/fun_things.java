
/*
    Generated by the Return of the Table compiler.
 */


import rtlib.*;
import java.util.Scanner;

class fun_things_anonymous_functor_1 implements FilterPredicate {
double rt7;

fun_things_anonymous_functor_1(double _rt7){rt7 = _rt7;}
public boolean test(Record record) {
                return ((((record).entries[1]._Float)!=(rt7)));
            }}
class fun_things_anonymous_functor_2 implements FilterPredicate {


fun_things_anonymous_functor_2(){}
public boolean test(Record record) {
                return ((((record).entries[0]._Integer)<(300)));
            }}


public class fun_things {
    static UserDefinedType rt0;
static UserDefinedType rt1;
static int rt2;
public static int rt6(int rt7) {
 return ((rt7)*(10));}

public static int rt5() {
{
System.out.println(((rt2)-(6)));
double rt7;
(rt7)=(95.);
System.out.println(((((fun_things.rt3()).filter(new fun_things_anonymous_functor_1(rt7))).filter(new fun_things_anonymous_functor_2())).prepend((new Record(fun_things.rt0, new Data((3)), new Data((95.)), new Data(("oh yea!")))))));
System.out.println((rt2));
 return (100);

}}

public static double rt4(double rt7) {
{
System.out.println((rt7));
 return (rt7);

}}

public static Table rt3() {
{
int rt7;
(rt7)=(1000000);
System.out.println(("This is fun to me."));
(rt2)=(rt7);
boolean rt8;
(rt8)=(true);
double rt9;
(rt9)=(3.23);
Record rt10;
(rt10)=(new Record(fun_things.rt0, new Data((rt2)), new Data((rt9)), new Data(("s"))));
 if ((rt7)>(100)) {{
System.out.println(((rt10).entries[2]._String));
((rt10).entries[2]._String)=("almost done");

}} else {{

}}
Table rt11;
(rt11)=(((new Table((new Record(fun_things.rt0, new Data((rt2)), new Data((rt9)), new Data(("s")))))).addRow((new Record(fun_things.rt0, new Data((0)), new Data((42.)), new Data((" is the meaning of life")))))).addRow((new Record(fun_things.rt0, new Data((73)), new Data((9.8)), new Data(("gravity"))))));
 return (rt11);

}}

    private static Scanner input;
		static String globArgs[];
    
	public static void main(String args[]) {
        input = new Scanner(System.in);
				globArgs = new String[args.length];
				for(int globArgCounter = 0; globArgCounter < args.length; globArgCounter++)
					globArgs[globArgCounter] = args[globArgCounter];
				
        fun_things.rt0 = new UserDefinedType("Fun");
fun_things.rt0.add("Fun's f", Data.INT_TYPE);
fun_things.rt0.add("Fun's k", Data.FLOAT_TYPE);
fun_things.rt0.add("Fun's s", Data.STRING_TYPE);

fun_things.rt1 = new UserDefinedType("Thing");
fun_things.rt1.add("Thing's this", Data.STRING_TYPE);
fun_things.rt1.add("Thing's is", Data.STRING_TYPE);
fun_things.rt1.add("Thing's fun", Data.STRING_TYPE);

{
(rt2)=(((2)*(3))+(1));
System.out.println((fun_things.rt6((fun_things.rt5()))));

}
    }    
}

