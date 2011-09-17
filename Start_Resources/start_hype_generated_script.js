//	HYPE.documents["Start"]

(function HYPE_DocumentLoader() {
	var resourcesFolderName = "Start_Resources";
	var documentName = "Start";
	var documentLoaderFilename = "start_hype_generated_script.js";

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

var scenes = [{"timelines":{"kTimelineDefaultIdentifier":{"framesPerSecond":30,"animations":[{"startValue":"0.000000","isRelative":true,"endValue":"1.000000","identifier":"Opacity","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"8942A267-6EC6-4FF0-83C9-F1433DCC2A2B-9965-0000AFDA3842E467","startTime":0},{"startValue":"0.000000","isRelative":true,"endValue":"1.000000","identifier":"Opacity","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"4C68C631-06E6-43C1-A39B-1950F7774E01-9965-0000AFFBD5BDF852","startTime":0},{"startValue":"0.000000","isRelative":true,"endValue":"1.000000","identifier":"Opacity","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"2A060B45-3318-4B1A-97BC-9716C6E15DB1-9965-0000AFE89B222DA6","startTime":0},{"startValue":"0.000000","isRelative":true,"endValue":"1.000000","identifier":"Opacity","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"3ABDFCEA-6715-459E-A9C3-ADD5D792683F-9965-0000AFCF0160683C","startTime":0},{"startValue":"0.000000","isRelative":true,"endValue":"1.000000","identifier":"Opacity","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"A9E07853-5614-4805-BB18-CD2AD4172649-9965-0000B0133DDEC660","startTime":0},{"startValue":"247px","isRelative":true,"endValue":"323px","identifier":"Width","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"3ABDFCEA-6715-459E-A9C3-ADD5D792683F-9965-0000AFCF0160683C","startTime":0},{"startValue":"247px","isRelative":true,"endValue":"323px","identifier":"Height","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"3ABDFCEA-6715-459E-A9C3-ADD5D792683F-9965-0000AFCF0160683C","startTime":0},{"startValue":"226px","isRelative":true,"endValue":"188px","identifier":"Left","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"3ABDFCEA-6715-459E-A9C3-ADD5D792683F-9965-0000AFCF0160683C","startTime":0},{"startValue":"103px","isRelative":true,"endValue":"34px","identifier":"Top","duration":1.6666667461395264,"timingFunction":"easeinout","type":0,"oid":"3ABDFCEA-6715-459E-A9C3-ADD5D792683F-9965-0000AFCF0160683C","startTime":0}],"identifier":"kTimelineDefaultIdentifier","name":"Main Timeline","duration":1.6666667461395264}},"id":"7942345D-D22B-4A1C-BC36-6708A2243EFB-9965-0000AFA6A4160D61","sceneIndex":0,"perspective":"600px","oid":"7942345D-D22B-4A1C-BC36-6708A2243EFB-9965-0000AFA6A4160D61","initialValues":{"8942A267-6EC6-4FF0-83C9-F1433DCC2A2B-9965-0000AFDA3842E467":{"PaddingTop":"8px","Position":"absolute","InnerHTML":"We\u2019ve got lift off.","TagName":"div","PaddingRight":"8px","Display":"inline","Left":"143px","FontWeight":"bold","Overflow":"visible","Opacity":"0.000000","ZIndex":"2","FontSize":"50px","TextColor":"#505050","WordWrap":"break-word","WhiteSpaceCollapsing":"preserve","PaddingBottom":"8px","TextAlign":"center","PaddingLeft":"8px","Top":"301px"},"4C68C631-06E6-43C1-A39B-1950F7774E01-9965-0000AFFBD5BDF852":{"PaddingTop":"8px","Position":"absolute","InnerHTML":"Start Browsing","TagName":"div","PaddingRight":"8px","Display":"inline","Left":"290px","Cursor":"pointer","ActionOnMouseClick":{"type":5,"goToURL":"#","openInNewWindow":false},"Overflow":"visible","ZIndex":"4","FontSize":"16px","TextColor":"#005192","WordWrap":"break-word","WhiteSpaceCollapsing":"preserve","PaddingBottom":"8px","PaddingLeft":"8px","Top":"436px","Opacity":"0.000000"},"2A060B45-3318-4B1A-97BC-9716C6E15DB1-9965-0000AFE89B222DA6":{"LineHeight":"20px","TagName":"div","PaddingRight":"8px","FontSize":"14px","Opacity":"0.000000","Display":"inline","WordWrap":"break-word","Top":"366px","PaddingBottom":"8px","WhiteSpaceCollapsing":"preserve","Position":"absolute","Height":"54px","Left":"60px","TextAlign":"center","InnerHTML":"<div>I wanted to say thanks and welcome you. I\u2019m still learning how to fly so please be&nbsp;patient with me. I\u2019ll be able to leave the nest soon enough and go as far as you would like.</div>","ZIndex":"3","PaddingLeft":"8px","Width":"563px","PaddingTop":"8px","Overflow":"visible","TextColor":"#3F3F3F"},"3ABDFCEA-6715-459E-A9C3-ADD5D792683F-9965-0000AFCF0160683C":{"Position":"absolute","BackgroundOrigin":"content-box","Left":"226px","Display":"inline","BackgroundImage":"feather_main.png","Height":"247px","Overflow":"visible","BackgroundSize":"100% 100%","ZIndex":"1","Top":"103px","Width":"247px","Opacity":"0.000000","TagName":"div"},"A9E07853-5614-4805-BB18-CD2AD4172649-9965-0000B0133DDEC660":{"Position":"absolute","BackgroundOrigin":"content-box","Left":"411px","Display":"inline","BackgroundImage":"arrow.png","Height":"15px","Overflow":"visible","BackgroundSize":"100% 100%","ZIndex":"5","Top":"445px","Width":"15px","Opacity":"0.000000","TagName":"div"}},"name":"Untitled Scene","backgroundColor":"#E8E9E8"}];

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
	hypeDoc.mainContentContainerID = "start_hype_container";
	hypeDoc.resourcesFolderName = resourcesFolderName;
	hypeDoc.showHypeBuiltWatermark = 0;
	hypeDoc.showLoadingPage = false;
	hypeDoc.drawSceneBackgrounds = true;
	hypeDoc.documentName = documentName;

	HYPE.documents[documentName] = hypeDoc.API;

	hypeDoc.documentLoad(this.body);
}());

