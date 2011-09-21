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

var scenes = [{"timelines":{"kTimelineDefaultIdentifier":{"framesPerSecond":30,"animations":[],"identifier":"kTimelineDefaultIdentifier","name":"Main Timeline","duration":0}},"id":"61487982-D198-425F-BE82-8913FCB4A118-9965-0000B0D59DE89E8E","sceneIndex":0,"perspective":"600px","oid":"61487982-D198-425F-BE82-8913FCB4A118-9965-0000B0D59DE89E8E","initialValues":{"5695411B-A507-47E9-81A1-37DDB61D5FED-9965-0000B11C99377040":{"PaddingTop":"8px","Position":"absolute","TagName":"div","PaddingRight":"8px","Display":"inline","UserSelect":"none","Left":"61px","Cursor":"pointer","ActionOnMouseClick":{"type":5,"goToURL":"http://start.raven.io","openInNewWindow":true},"Overflow":"visible","ZIndex":"4","FontSize":"16px","TextColor":"#005192","WordWrap":"break-word","WhiteSpaceCollapsing":"preserve","PaddingBottom":"8px","PaddingLeft":"8px","Top":"545px","InnerHTML":"Start Browsing"},"E25B0F2F-56DA-4494-8F7D-B38CF28B8B22-9965-0000B10A4FDF6866":{"PaddingTop":"8px","Position":"absolute","InnerHTML":"For too long our valuable browsing history has been treated a simple list of links or a menu. Not anymore. Raven's history browser provides a clean, easy to read list of the pages you've visited with a preview pane.","TagName":"div","PaddingRight":"8px","Display":"inline","Left":"61px","LineHeight":"22.5381px","Overflow":"visible","Height":"77px","ZIndex":"3","FontSize":"16px","TextColor":"#505050","WordWrap":"break-word","WhiteSpaceCollapsing":"preserve","PaddingBottom":"8px","PaddingLeft":"8px","Width":"525px","Top":"452px"},"2BEF180F-7E53-4764-927E-A0BD3A00D638-9965-0000B0F9D5363235":{"PaddingTop":"8px","Position":"absolute","TagName":"div","PaddingRight":"8px","Display":"inline","Left":"61px","FontWeight":"bold","Overflow":"visible","ZIndex":"2","FontSize":"24px","TextColor":"#505050","WordWrap":"break-word","WhiteSpaceCollapsing":"preserve","PaddingBottom":"8px","PaddingLeft":"8px","Top":"412px","InnerHTML":"History"},"70160C8E-D2C9-495B-BC52-7859D6D856BB-9965-0000B1267B16DBA2":{"Position":"absolute","BackgroundOrigin":"content-box","Display":"inline","UserSelect":"none","BackgroundImage":"arrow.png","Left":"182px","Cursor":"pointer","Overflow":"visible","BackgroundSize":"100% 100%","ZIndex":"5","Height":"15px","ActionOnMouseClick":{"type":5,"goToURL":"http://start.raven.io","openInNewWindow":true},"Width":"15px","Top":"555px","TagName":"div"},"8B937346-7624-464F-BD01-15CE4D3A0E75-9965-0000B34F6333AD51":{"Position":"absolute","BackgroundOrigin":"content-box","Left":"46px","Display":"inline","BackgroundImage":"history.png","Height":"387px","Overflow":"visible","BackgroundSize":"100% 100%","ZIndex":"6","Top":"31px","Width":"572px","TagName":"div"}},"name":"Untitled Scene","backgroundColor":"#E8E9E8"}];

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

