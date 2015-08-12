import gifAnimation.*;

String inp, ext, exp;
int wid, hei;
int spc, nf, dly;
boolean loop;

void setup() {
  //size(200, 200);
  //background(0);
  
  inp = "import/img_";
  ext = ".png";
  exp = "export/exp";
  
  wid = 0;
  hei = 0;
  
  spc = 1;
  nf = 3;
  dly = 30; //min:20
  
  loop = true;
  
  GifMaker g_exp;
  ArrayList<PImage> load = new ArrayList<PImage>();
  int i;
  
  i=0;
  do{
    i++;
    load.add(loadImage(inp+nf(i*spc, nf)+ext));
  }while(load.get(i-1)!=null);
  load.remove(i-1);
  
  wid = (0<wid?wid:load.get(0).width);
  hei = (0<hei?hei:load.get(0).height);
  
  g_exp = new GifMaker(this, exp+".gif");
  
  g_exp.setSize(wid, hei);
  g_exp.setRepeat((loop?0:1));
  
  for(i=0;i<load.size();i++){
    g_exp.setDelay(dly);
    g_exp.addFrame(load.get(i));
  }
  g_exp.finish();
  
  exit();
}

void draw() {
  //g_exp.addFrame();
}

