
/*
    Generated by the Return of the Table compiler.
 */


import rtlib.*;
import java.util.Scanner;



public class commandLine {
    static int rt0;
public static void rt1() {
{
System.out.println((globArgs.length));
 for ((rt0)=(0); (rt0)<(globArgs.length); (rt0)=((rt0)+(1))){{
System.out.println((globArgs[(rt0)]));

}}

}}

    private static Scanner input;
		static String globArgs[];
    
	public static void main(String args[]) {
        input = new Scanner(System.in);
				globArgs = new String[args.length];
				for(int globArgCounter = 0; globArgCounter < args.length; globArgCounter++)
					globArgs[globArgCounter] = args[globArgCounter];
				
        {
System.out.println((globArgs.length));
 for ((rt0)=(0); (rt0)<(globArgs.length); (rt0)=((rt0)+(1))){{
System.out.println((globArgs[(rt0)]));

}}
commandLine.rt1();

}
    }    
}

