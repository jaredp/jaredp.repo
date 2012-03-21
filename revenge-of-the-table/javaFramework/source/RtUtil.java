// Michael Vitrano and Jared Pochtar

package rtlib;
import java.io.*;

public class RtUtil{
	
	
	public static String System(String command){
		try{
		Process p=Runtime.getRuntime().exec(command); 
		p.waitFor(); 
		BufferedReader reader=new BufferedReader(new InputStreamReader(p.getInputStream())); 
		String test = reader.readLine();
		String out = "";
		while(test != null) { 
			out += test + "\n";
			test=reader.readLine(); 
		}
		return out;
	}catch(Exception e){
		return null;
	}
	}
	
	
}
