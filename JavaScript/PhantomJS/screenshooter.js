console.log(Array(31).join('-'));
console.log('------- ScreenShooter --------');
console.log(Array(31).join('-'));
console.log('');

var system = require('system');

if ((system.args[1].toLowerCase() === '--help' || system.args[1].toLowerCase() === '-h') || system.args.length < 2) {

    console.log('Arguments:')
    console.log('1.  URL*                                                                example: https://example.com')
    console.log('2.  Filename                     default: screenshot_[timestamp].png    example: example.pdf')
    console.log('3.  Waiting for rendering        default: 0')
    console.log('4.  Screen width                 default: 1366')
    console.log('5.  Screen height                default: 768')
    console.log('6.  Screenshot top position**');
    console.log('7.  Screenshot left position**');
    console.log('8.  Screenshot width size**');
    console.log('9.  Screenshot height size**');
    console.log('10. Image zoom index             default: 1**');
    console.log('*mandatory field');
    console.log('**if omitted then fullscreen');
    console.log('');
    console.log('Example: phantomjs screenshooter.js http://google.com google.png 740 683');
    console.log('For help use --help or -h');
    console.log('');
    console.log('undergrinder 2016');
    console.log('Last update: 2018-03-06');
    phantom.exit();
}

//Parameter INIT
var currentdate = new Date();
var page        = require('webpage').create();
var scrshtURL   = system.args[1];
var fileName    = system.args[2];
var renderTime  = system.args[3];
var vWidth      = system.args[4];
var vHeight     = system.args[5];
var pTop        = system.args[6];
var pLeft       = system.args[7];
var pWidth      = system.args[8];
var pHeight     = system.args[9];
var vZoom       = system.args[10];

if (scrshtURL.toUpperCase().substring(1, 4) != 'HTTP') {
        scrshtURL = 'http://' + scrshtURL;
}

//SET DEFAULTS
if(!fileName){fileName = 'screenshot_' + currentdate.getTime() + '.png';}
if(!renderTime){renderTime=0;}
if(!vWidth||!vHeight){vWidth = 1366;
                      vHeight = 768;}
    
//Print parameters
    console.log('Arguments in Batch: ' + (system.args.length - 1));
    console.log('1. URL: ' + scrshtURL);
    console.log('2. Filename : ' + fileName);
    console.log('3. Waiting for rendering : ' + renderTime);
    console.log('4. Browser screen width : ' + vWidth);
    console.log('5. Browser screen height : ' + vHeight);
    
if (pTop && pLeft && pWidth && pHeight) {
    console.log('6.  Screenshot top position: ' + pTop);
    console.log('7.  Screenshot left position: ' + pLeft);
    console.log('8.  Screenshot width size: ' + pWidth);
    console.log('9.  Screenshot height size : ' + pHeight);
    console.log('10. Image zoom index : ' + (isNaN(vZoom) ? 1 : vZoom) * 100 + '%');
} else {
   console.log('6. Screenshot size: full webpage');
    }

    console.log('');

//Main()
page.viewportSize = {width:  vWidth,
                     height: vHeight};

page.open(scrshtURL, function(status) {

    console.log('URL status: ' + status);

    if (status == 'success') {

        console.log('Waiting for the page rendering...');

        window.setTimeout(function() {
            
            if (pTop && pLeft && pWidth && pHeight) {
                   page.clipRect = {top: pTop,
                                    left: pLeft,
                                    width: pWidth,
                                    height: pHeight};
            }
            if (!isNaN(vZoom)) {page.zoomFactor = vZoom;}
            
            page.render(fileName);
            
            console.log('End of Process');
            phantom.exit();
            
        }, renderTime);

    } else {
        console.log('For help use --help or -h');
        console.log('Example: phantomjs screenshooter.js http//google.com google.png 740 683');
        phantom.exit();
    }
});