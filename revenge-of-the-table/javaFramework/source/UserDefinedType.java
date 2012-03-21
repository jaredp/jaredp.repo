// Michael Vitrano and Jared Pochtar

package rtlib;

import java.util.ArrayList;
import java.lang.Math;


public class UserDefinedType {
	
	ArrayList<String> names;
	ArrayList<Integer> types;
	String name;
	boolean isTuple;
	
	public UserDefinedType(String aName){
		name = aName;
		types = new ArrayList<Integer>();
		names = new ArrayList<String>();
		isTuple = false;
	}
	public void add(String name, int type){
		types.add(type);
		names.add(name);
	}
	
	public void addCompType(ArrayList<String> newNames, ArrayList<Integer> newTypes){
		names.addAll(newNames);
		types.addAll(newTypes);
	}
	
	public int[] typeList(){
		int a[] = new int[types.size()];
		
		for(int i = 0; i < types.size(); i++){
			a[i] = types.get(i);
		}
		return  a;
	}
	public String[] nameList(){
		String a[] = new String[names.size()];
		
		for(int i = 0; i < names.size(); i++){
			a[i] = names.get(i);
		}
		return  a;
	}
	
	public int getSize(){
     	return names.size();
    }

	public static TupleType combineTypes(UserDefinedType a, UserDefinedType b){
 			return new TupleType(a.name + b.name, a, b);
	}
	
	public String toString(){
		String out = "| ";
		for(String name : names){
			out += name + "\t| ";
		}
		return out;
	}
	
	public String toString(int[] size){
		String out = "| ";
		for(int i = 0; i < names.size(); i++){
			String name = names.get(i);
			int frontPad, backPad;
			if(name.length() < size[i]){
				frontPad = (int) Math.floor((size[i]-name.length())/2.0);
				backPad = size[i]-name.length() - frontPad;
			}else{
				frontPad = 0;
				backPad = 0;
			}
			for(int j = 0; j < frontPad; j++)
				out += " ";
			out += name;
			for(int j = 0; j < backPad; j++)
				out += " ";
			out += " | ";
		}
		return out;
	}
    
    public String toFile(){
     String out = "";
		for(int i = 0; i < names.size(); i++){
       	   if( i != names.size() - 1 )
              out += names.get(i) + ",";
            else
              out += names.get(i);
		}
		return out;
    }

}
