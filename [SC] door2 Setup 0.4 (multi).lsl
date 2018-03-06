/*This is a setup script for brittylicious's door2 0.6 script
How to use:
1. place this script in the door your want to set up
2. click on the door and a menu will pop up
3. make sure the door is in the position you want(either opened or close)
4. then select the option from the menu(set door close/ set door open)
5. when you done just select done from the menu and now place the door2 0.6 script int the door
6. copy and paste the set up from the chat to the door2 0.6 script and save


if you have any door which are in more than one part:

just add the prefix 'dr_' to the child part of the door
the script will auto detect it
you can change the prefix from the script variables
when you click done it will show you the params for the linked part too


more inf or or want to contribute to it,see the github repo @
https://github.com/ShanaPearson/SC-door2-0.6-setup

*/
//===================================Variables=====================================

string closePos;
string closeRot;
string openPos;
string openRot;

rotation initRot;
vector initPos;

integer i;
integer j;
integer var;
integer length;
integer cnt;

string prefix= "dr_"; //*** PREFIX IS HERE ****
list linkName =[];
list link=[];
list linkClose;
list linkOpen;

list alpha=["","b","c","d","e","f","g","h","i"];

list linkInit=[];

//====================================================================================

find_link()
{
    integer prims = llGetNumberOfPrims();
    integer index;

    while(prims--)
    {
        string name = llGetLinkName(index);

        if(llGetSubString(name, 0, 2) == prefix)
        {
            link = link + index;
            linkName=linkName+name;
        }

        index++;
    }
    cnt = llGetListLength(link);
    llOwnerSay("Number of linked parts found:" +(string)cnt);
    llSay(0,"Number of linked parts found:" +(string)cnt);
}



dump()
{
if(link!=[])
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
       // llOwnerSay("I: "+(string)i+"\n J: "+(string)j );
                  
       llOwnerSay("\nstring link"+llList2String(alpha, i)+"_name =\""+llList2String(linkName, i)+"\";"
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

reset()
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
 llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POS_LOCAL, initPos, PRIM_ROT_LOCAL, initRot]);
 find_link();
}


list buttons = ["Set Open", "Set Close", "Reset","Done"];
string dialogInfo = "\nPlease make a choice.";
 
key ToucherID;
integer dialogChannel;
integer listenHandle;


default
{
    state_entry()
    {
       initRot= llGetLocalRot();
       initPos= llGetLocalPos();
       dialogChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) ); 
       reset();
       llOwnerSay("Setup init...");
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
