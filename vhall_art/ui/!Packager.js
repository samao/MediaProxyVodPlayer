// 打包过程
///////////////////////////////////////////////////////////////////////

//用于打包当前目录下的所有图片
var fso = new ActiveXObject("Scripting.FileSystemObject");

var fldr = fso.GetFolder(".");

var tFile = fso.CreateTextFile("run.jsfl", true);
tFile.writeLine('fl.runScript("file:///createDocument.jsfl","createDocument");');

var tureFolderName = fldr.name;
var folderName = fldr.name.split("_")[0];

var classArr=new Array();
var dicArr=new Array();
var itemIndex = 1000;

//将路径转为绝对路径
var fldPath = fldr.path.replace(/\\/g,"/");
fldPath=fldPath.replace(":","|");
scanFla(fldPath, fldr);

tFile.writeLine('fl.runScript("file:///exportSwf.jsfl","exportSwf");');
tFile.writeLine('fl.quit(false);');
tFile.close();

createMoveJS();
generateDocumentClass();
createCreateDocument();
createImportSwf();
createExportSwf();

createBat();
var ws=new ActiveXObject("WScript.Shell");
ws.Run("runjsfl.Bat");

//---------------------------------------

function scanFla(dirName, fldr)
{
	for (var enumSubFolders = new Enumerator(fldr.SubFolders); !enumSubFolders.atEnd(); enumSubFolders.moveNext())
	{
		// 获取当前目录
		var objCurrFolder = enumSubFolders.item();
		// 扫描子目录
		scanFla(dirName + "/" + objCurrFolder.name, objCurrFolder);
	}

	var fc = new Enumerator(fldr.files);
	while(!fc.atEnd()){
		var name = fc.item().name;
		if((name.indexOf(".png") > 0 || name.indexOf(".jpg")>0 )&& name.indexOf(".svn")<0){
			 //获取相对路径
			 var path = dirName.substr(fldPath.length);
			 dicArr.push(path+"/"+name);
			 classArr.push(folderName+itemIndex);
			 tFile.write('fl.runScript("file:///importReSwf.jsfl","importSwf"');
			 tFile.write(',"file:///'+dirName+"/"+name+'"');
			 tFile.write(',"'+folderName+itemIndex+'"');
			 tFile.write(',"'+name+'"');
			 tFile.writeLine(');');
			 itemIndex++;
		}
		fc.moveNext();
	}
}

////生成swf的文档类
function generateDocumentClass()
{
		var docFile = fso.CreateTextFile(tureFolderName+".as",true,true);
		docFile.writeLine("package");
		docFile.writeLine("{");
		docFile.writeLine("import flash.display.MovieClip;");
		docFile.writeLine("import flash.display.Sprite;");
		docFile.writeLine("import flash.utils.Dictionary;");
		docFile.writeLine("import flash.display.BitmapData;");
		docFile.writeLine("import flash.display.Bitmap;");
		docFile.writeLine("public class "+tureFolderName+" extends Sprite");
		docFile.writeLine("{");	
		docFile.writeLine(" ");	
		docFile.writeLine("public var map:Object = {};");	
		
		docFile.writeLine("public function getAssets():Object");
		docFile.writeLine("{");	
		
		for (var i=0;i<classArr.length;i++)
		{
			var path = "assets/" + folderName+dicArr[i];
			docFile.writeLine('	 map["'+path+'"]='+classArr[i]+';');	
		}
		docFile.writeLine("return map;");	

		
		docFile.writeLine("}");
		docFile.writeLine("}");
		docFile.writeLine("}");
		docFile.close();
}
//创建swf
function createCreateDocument()
{
		var docFile = fso.CreateTextFile("createDocument.jsfl", true);
		docFile.writeLine("var lib;");
		docFile.writeLine("var doc;");
		docFile.writeLine('function createDocument()');
		docFile.writeLine('{');
		docFile.writeLine('doc=fl.createDocument();');
		docFile.writeLine('}');
		docFile.close();
}
//导入图到swf


function createImportSwf()
{
		var docFile = fso.CreateTextFile("importReSwf.jsfl", true);
		docFile.writeLine("var lib;");
		docFile.writeLine("var doc;");
		docFile.writeLine("function importSwf(importFilePath,className,itemName)");
		docFile.writeLine("{");
		docFile.writeLine("doc=fl.getDocumentDOM();");
		docFile.writeLine("lib=doc.library;");
		docFile.writeLine("setFile(importFilePath,className,itemName);");
		docFile.writeLine("}");
		docFile.writeLine("function setFile(importFilePath,className,itemName)");
		docFile.writeLine("{");
		docFile.writeLine('if (importFilePath!="file:///0" && importFilePath!="file:///undefined" && importFilePath!="0")');
		docFile.writeLine("{");
		docFile.writeLine("fl.trace(importFilePath)");
		docFile.writeLine("doc.importFile(importFilePath,true);");
		docFile.writeLine("setBitmapData(className,itemName);");
		docFile.writeLine("}");
		docFile.writeLine("}");
		docFile.writeLine("function setBitmapData(className,itemName)");
		docFile.writeLine("{");
		docFile.writeLine("var i;");
		docFile.writeLine("i=lib.findItemIndex(itemName);");
		docFile.writeLine("fl.trace(className);");
		docFile.writeLine("lib.items[i].linkageExportForRS = true;");
		docFile.writeLine("lib.items[i].linkageExportForAS = true;");
		docFile.writeLine("lib.items[i].linkageExportInFirstFrame=true;");
		docFile.writeLine('lib.items[i].linkageIdentifier="s"+className;');
		docFile.writeLine("lib.items[i].linkageClassName = className;");
		docFile.writeLine('lib.items[i].linkageBaseClass = "flash.display.BitmapData"; ');
		docFile.writeLine('lib.items[i].compressionType="photo";');
		docFile.writeLine('lib.items[i].quality = 80;');
		docFile.writeLine('lib.items[i].name=itemName+"::"+className;');
		docFile.writeLine("}");
		docFile.close();
}
//生成swf
function createExportSwf()
{
		var docFile = fso.CreateTextFile("exportSwf.jsfl", true);
		docFile.writeLine("var lib;");
		docFile.writeLine("var doc;");
		docFile.writeLine('function exportSwf()');
		docFile.writeLine('{');
		docFile.writeLine('doc=fl.getDocumentDOM();');
		
		//限度出来再写进去可避免编码问题。
		docFile.writeLine('   var txt = FLfile.read("file:///'+tureFolderName+'.as");');
		docFile.writeLine('	   FLfile.write("file:///'+tureFolderName+'.as",txt);');
		
		docFile.writeLine('doc.docClass="'+tureFolderName+'";');
		
		
		docFile.writeLine('fl.saveDocument(doc,"file:///'+tureFolderName+'.fla");');
		docFile.writeLine('doc.exportSWF("file:///'+tureFolderName+'.swf",true);');
		docFile.writeLine('doc.close(false);');

		docFile.writeLine('FLfile.remove("file:///createDocument.jsfl");');
		docFile.writeLine('FLfile.remove("file:///exportSwf.jsfl");');
		docFile.writeLine('FLfile.remove("file:///'+tureFolderName+'.fla");');
		docFile.writeLine('FLfile.remove("file:///importReSwf.jsfl");');
		docFile.writeLine('FLfile.remove("file:///run.jsfl");');
		docFile.writeLine('FLfile.remove("file:///'+tureFolderName+'.as");');
		docFile.writeLine('}');
		docFile.close();
}
//最后运行所有jsfl
function createBat()
{
		var bat=fso.CreateTextFile("runjsfl.bat", true);
		bat.writeLine("run.jsfl");
		bat.writeLine("wscript.exe move.js");
		bat.close();
//alert=function(s){WScript.Echo(s)};
//var arg=WScript.arguments(0);
//alert(arg);
}
function createMoveJS()
{
		var docFile = fso.CreateTextFile("move.js", true);
		docFile.writeLine('var fso = new ActiveXObject("Scripting.FileSystemObject");');
		docFile.writeLine('var swfFile=fso.GetFile("'+tureFolderName+'.swf");');
		//docFile.writeLine('swfFile.Copy("target/'+folderName+'.swf");');
		//docFile.writeLine('swfFile.Delete();');
		
		docFile.writeLine('var runFile=fso.GetFile("runjsfl.bat");');
		docFile.writeLine('runFile.Delete();');
		
		docFile.writeLine('var moveFile=fso.GetFile("move.js");');
		docFile.writeLine('moveFile.Delete();');

		docFile.close();
}
