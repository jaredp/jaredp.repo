
/*
    Generated by the Return of the Table compiler.
 */


import rtlib.*;
import java.util.Scanner;



public class BooleanLogic {
    static int rt0;
static boolean rt1;
static String rt2;
static String rt3;
static String rt4;
static double rt5;


    private static Scanner input;
		static String globArgs[];
    
	public static void main(String args[]) {
        input = new Scanner(System.in);
				globArgs = new String[args.length];
				for(int globArgCounter = 0; globArgCounter < args.length; globArgCounter++)
					globArgs[globArgCounter] = args[globArgCounter];
				
        {
(rt0)=(5);
 if ((rt0)!=(5)) {{
(rt1)=(true);

}} else {{

}}
(rt2)=("alpha");
(rt3)=("beta");
System.out.println((rt2));
(rt4)=((rt2)+(rt3));
System.out.println((rt4));
 if (((rt2)+(rt3)).equals((rt4))) {{
(rt1)=(false);

}} else {{
(rt1)=(true);

}}
System.out.println((rt1));
(rt5)=(2.);
 while (true) {{

} if(!((rt0)>(0))) { break; } {
 if ((rt5)<(100.)) {{
(rt5)=((rt5)*(rt5));
System.out.println((rt5));

}} else { if ((rt5)<=(256.)) {{
(rt5)=((rt5)*(4.));
System.out.println((rt5));

}} else {{
(rt5)=((rt5)+(1.));
System.out.println((rt5));

}}}
(rt0)=((rt0)-(1));
System.out.println((rt0));

}}
System.out.println((rt5));
(rt5)=(137.5);
(rt4)=((rt2)+(rt2));
System.out.println((rt4));
 for ((rt0)=(5); (rt0)>(0); (rt0)=((rt0)-(1))){{
 if (((rt4).equals(((rt2)+(rt2))))||((rt0)==(2))) {{
(rt5)=((rt5)-(37.5));
(rt4)=((rt3)+(rt3));
System.out.println((rt5));
System.out.println((rt4));

}} else {{

}}
 if (((rt4).equals(((rt3)+(rt3))))&&((rt0)==(4))) {{
(rt5)=((rt5)+(100.));
(rt4)=((rt2)+(rt2));
System.out.println((rt5));
System.out.println((rt4));

}} else {{

}}
System.out.println((rt0));

}}

}
    }    
}

