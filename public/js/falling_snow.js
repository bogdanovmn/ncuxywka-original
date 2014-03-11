function rand(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;  
}
 
Amount = rand(15, 30);
grphcs = new Array(); 
grphcs[0] = "/img/sneg.gif"; 

Ypos = new Array(); 
Xpos = new Array(); 
Speed = new Array(); 
Step = new Array(); 
Cstep = new Array(); 
var YPosA; 

document.write('<div style="position:absolute;top:0px;left:0px"><div style="position:relative">'); 
for (i = 0; i < Amount; i++) { 
	var P = rand(0, grphcs.length - 1); 
	rndPic = grphcs[P]; 
	rnd_size = rand(10, 20);
	document.write('<img id="si'+i+'" src="'+rndPic+'" style="position:absolute; top:-101px; left:-101px; width:' + rnd_size + 'px; height:' + rnd_size + 'px;">'); 
} 
document.write('<\/div><\/div>'); 

var WinHeight = window.document.body.clientHeight; 
var WinWidth = window.document.body.clientWidth - 70; 
for (i = 0; i < Amount; i++) { 
  Ypos[i] = -1 * rand(10, 1500); 
  Xpos[i] = rand(0, WinWidth - 70); 
  Speed[i] = rand(2, 5); 
  Cstep[i] = 0; 
  Step[i] = Math.random()*0.1+0.05; 
} 
function snow_falling() { 
  var WinHeight = window.document.body.clientHeight; 
  var WinWidth =  window.document.body.clientWidth - 70; 
  var hscrll = document.body.scrollTop;
  var wscrll = document.body.scrollLeft; 
  for (i=0; i < Amount; i++) { 
    sy = Speed[i];//*Math.sin(90*Math.PI/180); 
    sx = Speed[i]*Math.cos(Cstep[i]); 
    Ypos[i] += sy; 
    Xpos[i] += sx; 
	if (Xpos[i] >= WinWidth - 70) { Xpos[i] -= 30; }
    if (Ypos[i] > WinHeight + hscrll + 300) { 
      Ypos[i] = -1 * rand(50, 500); 
      Xpos[i] = rand(0, WinWidth) - 70;  
      Speed[i] = rand(2, 5);  
	  rnd_size = rand(10, 20);
	  document.getElementById('si'+i).style.width = rnd_size + 'px';
	  document.getElementById('si'+i).style.height = rnd_size + 'px';
    } 
	document.getElementById('si'+i).style.left = Xpos[i]+'px'; 
	YPosA=Ypos[i] - hscrll; 
	document.getElementById('si'+i).style.top = YPosA+'px'; 
     
    Cstep[i] += Step[i]; 
  } 
  setTimeout('snow_falling()',50); 
}  
