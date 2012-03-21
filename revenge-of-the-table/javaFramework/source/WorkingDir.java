// Michael Vitrano and Jared Pochtar


package rtlib;

public class WorkingDir {
	
	private static String working;
	
	static {
        working = "./";
    }
	
	public static String getPath(String aPath){
		if(aPath.startsWith("/")) {
			return aPath;
		} else {
			return working + aPath;
        }
	} 
	
	public static void setPath(String aPath){
        working = aPath;
    }
	
	public static void defaultPath(){
        working = "./";
    }
}