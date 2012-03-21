// Michael Vitrano and Jared Pochtar

package rtlib;

import java.util.ArrayList;
import java.lang.Math;

public class TupleType extends UserDefinedType {
	
	ArrayList<UserDefinedType> compTypes;
	
	public TupleType(String aName, UserDefinedType ... components){
		super(aName);
		compTypes = new ArrayList<UserDefinedType>();
		for(int i = 0; i < components.length; i++){
			if(components[i].isTuple){
				@SuppressWarnings("unchecked")
				TupleType comp = (TupleType) components[i];
				this.compTypes.addAll(comp.compTypes);
			}else{
				compTypes.add(components[i]);
			}
			super.addCompType(components[i].names, components[i].types);
		}
		super.isTuple = true;
	}
		
	public int[] getTypeBounds(UserDefinedType type){
		int start, end, last;
		last = 0;
		//System.out.println("looking for " + type.name);
		
		for(int i = 0; i < compTypes.size(); i++){
			start = last;
			end = start + compTypes.get(i).getSize();
			last = end + 1;
			//System.out.println("examining " + compTypes.get(i).name);
			if (compTypes.get(i).name.equals(type.name) ){
				int ret[] = {start, end};
				//System.out.println("returning " + ret[0] +" , "+ret[1] );
				return ret;
			}
		}
		//System.out.println("returning null" );
		return null;
	}
	
	public void printStat(){
		System.out.println("name:" + super.name);
		System.out.println("col names:");
		for(String cName : super.names)
			System.out.println(cName);
		
		System.out.println("comp type names:");
		for(UserDefinedType cType : compTypes)
			System.out.println(cType.name);
		
		
	}
	


}


