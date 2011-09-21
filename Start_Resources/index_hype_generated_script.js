//	HYPE.documents["index"]

(function HYPE_DocumentLoader() {
	var resourcesFolderName = "index_Resources";
	var documentName = "index";
	var documentLoaderFilename = "index_hype_generated_script.js";

	// find the URL for this script's absolute path and set as the resourceFolderName
	try {
		var scripts = document.getElementsByTagName('script');
		for(var i = 0; i < scripts.length; i++) {
			var scriptSrc = scripts[i].src;
			if(scriptSrc != null && scriptSrc.indexOf(documentLoaderFilename) != -1) {
				resourcesFolderName = scriptSrc.substr(0, scriptSrc.lastIndexOf("/"));
				break;
			}
		}
	} catch(err) {	}

	// load HYPE.js if it hasn't been loaded yet
	if(typeof HYPE == "undefined") {
		if(typeof window.HYPE_DocumentsToLoad == "undefined") {
			window.HYPE_DocumentsToLoad = new Array();
			window.HYPE_DocumentsToLoad.push(HYPE_DocumentLoader);

			var headElement = document.getElementsByTagName('head')[0];
			var scriptElement = document.createElement('script');
			scriptElement.type= 'text/javascript';
			scriptElement.src = resourcesFolderName + '/' + 'HYPE.js';
			headElement.appendChild(scriptElement);
		} else {
			window.HYPE_DocumentsToLoad.push(HYPE_DocumentLoader);
		}
		return;
	}
	
	var attributeTransformerMapping = {"BorderColorRight":"ColorValueTransformer","BackgroundColor":"ColorValueTransformer","BorderWidthBottom":"PixelValueTransformer","WordSpacing":"PixelValueTransformer","BoxShadowXOffset":"PixelValueTransformer","Opacity":"FractionalValueTransformer","BorderWidthRight":"PixelValueTransformer","BorderWidthTop":"PixelValueTransformer","BoxShadowColor":"ColorValueTransformer","BorderColorBottom":"ColorValueTransformer","FontSize":"PixelValueTransformer","BorderRadiusTopRight":"PixelValueTransformer","TextColor":"ColorValueTransformer","Rotate":"DegreeValueTransformer","Height":"PixelValueTransformer","PaddingLeft":"PixelValueTransformer","BorderColorTop":"ColorValueTransformer","Top":"PixelValueTransformer","BackgroundGradientStartColor":"ColorValueTransformer","TextShadowXOffset":"PixelValueTransformer","PaddingTop":"PixelValueTransformer","BackgroundGradientAngle":"DegreeValueTransformer","PaddingBottom":"PixelValueTransformer","PaddingRight":"PixelValueTransformer","Width":"PixelValueTransformer","TextShadowColor":"ColorValueTransformer","BorderColorLeft":"ColorValueTransformer","ReflectionOffset":"PixelValueTransformer","Left":"PixelValueTransformer","BorderRadiusBottomRight":"PixelValueTransformer","LineHeight":"PixelValueTransformer","BoxShadowYOffset":"PixelValueTransformer","ReflectionDepth":"FractionalValueTransformer","BorderRadiusTopLeft":"PixelValueTransformer","BorderRadiusBottomLeft":"PixelValueTransformer","TextShadowBlurRadius":"PixelValueTransformer","TextShadowYOffset":"PixelValueTransformer","BorderWidthLeft":"PixelValueTransformer","BackgroundGradientEndColor":"ColorValueTransformer","BoxShadowBlurRadius":"PixelValueTransformer","LetterSpacing":"PixelValueTransformer"};

var scenes = [{"timelines":{"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5_hover":{"framesPerSecond":30,"animations":[{"startValue":"#FFFFFF","isRelative":true,"endValue":"#D8D8D8","identifier":"BackgroundGradientStartColor","duration":1,"timingFunction":"easeinout","type":0,"oid":"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5","startTime":0},{"startValue":"#D8D8D8","isRelative":true,"endValue":"#FFFFFF","identifier":"BackgroundGradientEndColor","duration":1,"timingFunction":"easeinout","type":0,"oid":"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5","startTime":0},{"startValue":"1px","isRelative":true,"endValue":"0px","identifier":"BoxShadowYOffset","duration":1,"timingFunction":"easeinout","type":0,"oid":"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5","startTime":0},{"startValue":"3px","isRelative":true,"endValue":"0px","identifier":"BoxShadowBlurRadius","duration":1,"timingFunction":"easeinout","type":0,"oid":"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5","startTime":0}],"identifier":"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5_hover","name":"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5_hover","duration":1},"kTimelineDefaultIdentifier":{"framesPerSecond":30,"animations":[],"identifier":"kTimelineDefaultIdentifier","name":"Main Timeline","duration":0}},"id":"63312270-7D17-479F-A107-D656370C794D-73864-00015045950F244D","sceneIndex":0,"perspective":"600px","oid":"63312270-7D17-479F-A107-D656370C794D-73864-00015045950F244D","initialValues":{"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5":{"PaddingBottom":"10px","BorderWidthLeft":"1px","Display":"inline","TagName":"div","BorderColorLeft":"#A0A0A0","UserSelect":"none","Overflow":"visible","TextAlign":"left","LineHeight":"17px","BoxShadowBlurRadius":"3px","BorderColorTop":"#A0A0A0","BackgroundGradientAngle":"0deg","ActionOnMouseClick":{"goToURL":"http://start.raven.io","type":5,"openInNewWindow":false},"BorderWidthBottom":"1px","WordSpacing":"0px","BorderStyleRight":"Solid","ZIndex":"5","BorderRadiusBottomRight":"6px","FontSize":"19px","BackgroundGradientStartColor":"#FFFFFF","Width":"169px","TextShadowXOffset":"0px","BorderColorRight":"#A0A0A0","BoxShadowColor":"#AFAFAF","PaddingLeft":"10px","BoxShadowXOffset":"0px","BorderColorBottom":"#A0A0A0","BoxShadowYOffset":"1px","Cursor":"pointer","Position":"absolute","BorderStyleTop":"Solid","TextShadowColor":"#FFFFFF","BorderRadiusBottomLeft":"6px","BorderRadiusTopLeft":"6px","Left":"104px","BorderRadiusTopRight":"6px","BorderStyleBottom":"Solid","Height":"20px","PaddingRight":"10px","FontWeight":"bold","WhiteSpaceCollapsing":"preserve","PaddingTop":"10px","BackgroundColor":"#F0F0F0","TextColor":"#0051A1","BorderWidthTop":"1px","Top":"412px","TextShadowBlurRadius":"0px","TextShadowYOffset":"1px","InnerHTML":"Start Browsing","WordWrap":"break-word","BackgroundGradientEndColor":"#D8D8D8","BorderStyleLeft":"Solid","BorderWidthRight":"1px","ButtonHover":"E0A49A27-3235-44D2-8DF2-ADD860A2995D-73864-000151558CA3CEC5_hover"},"CEC49235-17EC-477F-9515-A2841FDB0399-73864-00015090AE250AFA":{"BorderWidthLeft":"1px","TagName":"div","BorderColorBottom":"#A0A0A0","BorderStyleRight":"Solid","BorderStyleBottom":"Solid","BoxShadowBlurRadius":"5px","Top":"36px","BorderStyleLeft":"Solid","BorderWidthRight":"1px","BorderColorTop":"#A0A0A0","BorderColorLeft":"#A0A0A0","BoxShadowYOffset":"0px","UserSelect":"none","Position":"absolute","Height":"556px","Left":"31px","BoxShadowColor":"#959595","BorderColorRight":"#A0A0A0","BorderStyleTop":"Solid","BorderRadiusTopLeft":"10px","ZIndex":"1","Width":"858px","BorderWidthTop":"1px","BoxShadowXOffset":"0px","BorderRadiusBottomLeft":"10px","BorderRadiusTopRight":"10px","Overflow":"visible","BorderRadiusBottomRight":"10px","BorderWidthBottom":"1px","BackgroundColor":"#FFFFFF"},"9FCBC57D-B3C6-4DF2-B4DF-DC2C021DA682-73864-000150E9235CAEB7":{"Position":"absolute","BoxShadowXOffset":"0px","BackgroundOrigin":"content-box","Display":"inline","UserSelect":"none","BackgroundImage":"shop.png","Left":"400px","BoxShadowBlurRadius":"0px","Height":"547px","Overflow":"visible","BackgroundSize":"100% 100%","ZIndex":"2","BoxShadowColor":"#000000","BoxShadowYOffset":"0px","Width":"490px","Top":"43px","TagName":"div"},"377518D7-A904-4DC2-AEB9-5EB9520FDB48-73864-00015173AF680566":{"Position":"absolute","BackgroundOrigin":"content-box","Display":"inline","UserSelect":"none","BackgroundImage":"arrow.png","Left":"264px","Cursor":"pointer","Overflow":"visible","BackgroundSize":"100% 100%","ZIndex":"6","Height":"15px","ActionOnMouseClick":{"goToURL":"http://start.raven.io","type":5,"openInNewWindow":false},"Width":"15px","Top":"427px","TagName":"div"},"B58F7D5E-5F2C-4902-AA90-A43F02F19617-73864-00015105FF1F3E65":{"FontFamily":"'Helvetica Neue',Arial,Helvetica,Sans-Serif","TagName":"div","PaddingRight":"8px","FontSize":"17px","Display":"inline","WordWrap":"break-word","PaddingBottom":"8px","Top":"203px","UserSelect":"none","WhiteSpaceCollapsing":"preserve","Position":"absolute","Height":"162px","Left":"95px","InnerHTML":"Discover web applications with the new Web App Shop.<div><br></div><div>We're still in beta so you can only browse around and save favorites. Soon you'll be able to install these apps into Smart Bar.</div><div><br></div><div>Mind the sawdust and have fun.</div>","ZIndex":"4","Width":"332px","PaddingLeft":"8px","PaddingTop":"8px","Overflow":"visible","TextColor":"#666666"},"7E255F0F-9194-4E74-B98B-986C5C4390E8-73864-000150EFAA1D8109":{"FontFamily":"Helvetica,Arial,Sans-Serif","FontWeight":"normal","TagName":"div","PaddingRight":"8px","FontSize":"48px","LetterSpacing":"-2px","Display":"inline","WordWrap":"break-word","PaddingBottom":"8px","Top":"131px","UserSelect":"none","WhiteSpaceCollapsing":"preserve","Position":"absolute","Height":"46px","Left":"95px","InnerHTML":"Welcome...","ZIndex":"3","PaddingLeft":"8px","Width":"339px","PaddingTop":"8px","Overflow":"visible","TextColor":"#000000"}},"name":"Untitled Scene","backgroundColor":"#E2E4E2"}];

var javascriptMapping = {};


	
	var Custom = (function() {
	return {
	};
}());

	
	var hypeDoc = new HYPE();
	
	hypeDoc.attributeTransformerMapping = attributeTransformerMapping;
	hypeDoc.scenes = scenes;
	hypeDoc.javascriptMapping = javascriptMapping;
	hypeDoc.Custom = Custom;
	hypeDoc.currentSceneIndex = 0;
	hypeDoc.mainContentContainerID = "index_hype_container";
	hypeDoc.resourcesFolderName = resourcesFolderName;
	hypeDoc.showHypeBuiltWatermark = 0;
	hypeDoc.showLoadingPage = false;
	hypeDoc.drawSceneBackgrounds = true;
	hypeDoc.documentName = documentName;

	HYPE.documents[documentName] = hypeDoc.API;

	hypeDoc.documentLoad(this.body);
}());

