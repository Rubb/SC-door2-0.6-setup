string closePos;
string closeRot;
string openPos;
string openRot;

rotation initRot;
vector initPos;
list initLink =[];


integer i;
integer j;
integer var;
integer length;
integer cnt;

string prefix= "dr_"; //*** DEFAULT PREFIX IS HERE ****
list link=[];
list linkName=[];
list linkOpen=[];
list linkClose=[];
list alpha=["","b","c","d","e","f","g","h","i"];

list linkInit=[];



find_link()
{    
    integer prims = llGetNumberOfPrims();
    integer index=1;
    prefix= llList2String(llGetLinkPrimitiveParams(LINK_THIS, [ PRIM_DESC ]), 0);   
    while(prims--)
    {
        string name = llGetLinkName(index);
        if(llGetSubString(name, 0, 2) == prefix)
        {
            link=link+index;
            linkName=linkName+name;
        }
        index++;
    }
  cnt = llGetListLength(linkName);
  llOwnerSay("Prefix:"+prefix);
  llOwnerSay("Number of linked parts found= " +(string)cnt);
}



clear()
{
 closePos="";
 closeRot="";
 openPos="";
 openRot="";
 linkName =[];
 link =[];
 linkClose = [];
 linkOpen = [];
 cnt=0;
}


reset()
{
 llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POS_LOCAL, initPos, PRIM_ROT_LOCAL, initRot]);
 if(link!=[])
 { 
   i=0;
   length = llGetListLength(link);
   var=0;
   j=0;
   while(i++ < length); 
   {
    llSay(0,(string)i+" , "+(string)j+" , "+(string)var+ " , "+(string)length);
    j=i+var;
    llSetLinkPrimitiveParams(llList2Integer(link, i),[PRIM_POS_LOCAL,llList2Vector(linkInit, i),PRIM_ROT_LOCAL,llList2Rot(linkInit, j)]);
    var=var+1;
   }           
 }
}

init()
{
 initRot= llGetLocalRot();
 initPos= llGetLocalPos();
 if(link!=[])
 {
  i=0;
  length = llGetListLength(link);
  do
   linkInit = linkInit +  llGetLinkPrimitiveParams(llList2Integer(link, i),[PRIM_POS_LOCAL,PRIM_ROT_LOCAL]);
  while(++i < length);            
  }
}


dump()
{
if(linkName!=[])
{   
   llOwnerSay("\nvector close_position = " + closePos + ";"
            + "\nrotation close_rotation = " + closeRot + ";"
            + "\n\nvector open_position = " + openPos + ";"
            + "\nrotation open_rotation = " + openRot + ";"
            +"\n"
             );        
       i=0;
       length = llGetListLength(linkName);
       var=0;
       j=0;
       while (i < length)
       {
        j=i+var;
        llOwnerSay("\nstring link_name =\""+llList2String(linkName, i)+"\";"
         +"\nvector link"+llList2String(alpha, i)+"_close_position = "+llList2String(linkClose, j)+";"
         +"\nrotation link"+llList2String(alpha, i)+"_close_rotation ="+llList2String(linkClose, j+1)+";"
         +"\nvector link"+llList2String(alpha, i)+"_open_position ="+llList2String(linkOpen, j)+";"
         +"\nrotation link"+llList2String(alpha, i)+"_open_rotation ="+llList2String(linkOpen, j+1)+";"
         );
         ++i;
         var=var+1;
       }       
 }
  else
 { llOwnerSay("\nvector close_position = " + closePos + ";"
            + "\nrotation close_rotation = " + closeRot + ";"
            + "\n\nvector open_position = " + openPos + ";"
            + "\nrotation open_rotation = " + openRot + ";"
            );}
}



list buttons = ["Set Open", "Set Close", "Reset","Done"];
string dialogInfo = "\nPlease make a choice.";
 
key ToucherID;
integer dialogChannel;
integer listenHandle;


default
{
     state_entry()
    {  clear();
       find_link();
       init();
       
       dialogChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) ); 
       llOwnerSay("Setup loaded");
    }
    
    touch_start(integer num_detected)
    {
        ToucherID = llDetectedKey(0);
        listenHandle = llListen(dialogChannel, "", ToucherID, "");
        llDialog(ToucherID, dialogInfo, buttons, dialogChannel);
    }
    
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Set Open")
        {          
            openPos = (string)llGetLocalPos();
            openRot = (string)llGetLocalRot(); 
             if(link!=[])
             {
                i=0;
                length = llGetListLength(link);
              do
               linkOpen = linkOpen +  llGetLinkPrimitiveParams(llList2Integer(link, i),[PRIM_POS_LOCAL,PRIM_ROT_LOCAL]);
              while(++i < length);
              
             }
            llOwnerSay("Opened set");      
        }
        if (message == "Set Close")
        {
             closePos = (string)llGetLocalPos();
             closeRot = (string)llGetLocalRot();
             if(link!=[])
             {
                 i=0;
                 length = llGetListLength(link);
                do
                 linkClose = linkClose + llGetLinkPrimitiveParams(llList2Integer(link, i),[PRIM_POS_LOCAL,PRIM_ROT_LOCAL]);
                while(++i < length);
                
             }
              llOwnerSay("Closed set");
        }
        if (message == "Done")
        {
           
           if( openPos=="" || openRot == "" || closePos == "" || closeRot == "" )
           {llOwnerSay("Door has not been set up correctly");}
           else
           {
            dump();
            llRemoveInventory(llGetScriptName());
           }
        }
        if (message == "Reset")
        {
          reset();
        }
    }
}
