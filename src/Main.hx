import hxd.Key;
import hxd.fmt.hmd.Data.Index;
import hscript.Expr;
import h2d.Text;
import h2d.Flow;

var script = 
"
say('Hello Traveler. Welcome to my shop.');
say('How may I help you?')
    choose('Buy', BuyShop)
    choose('Chat')
    choose('No Thanks')
endSay();
say('Thanks, come again!')";

var choices: Array<String> = ["1) Buy", "2) Chat", "3) Seeya Later!"];

class Chatbox {
    var chatFlow: Flow;
    var chunks: Array<String>;
    var showChunks = -1;
    var message: h2d.Text;
    var choiceMessages: Array<h2d.Text>;

    var dtAccum = 0.;
    var waitTime = 0.;
    var pauseTime = .3;
    var punctionTime = .7;
    var choice: Int;
    public var done = false;

    public function new(parent: h2d.Scene){
        chatFlow = new Flow(parent);
    }

    public function start(msg: String) {
        done = false;
        chunks = msg.split(" ");
        chatFlow.layout = FlowLayout.Vertical;
        message = new h2d.Text(hxd.res.DefaultFont.get(), chatFlow);
        message.text = "";
        choiceMessages = new Array<Text>();
        for(i in 0...4)
            choiceMessages.push(new h2d.Text(hxd.res.DefaultFont.get(), chatFlow));
    }

    public function update(dt: Float) {
        dtAccum += dt;
        if(dtAccum < waitTime) return;
        // Slow show message. Then, if choices exist, wait for a choice. Else we are done.
        if(showChunks < chunks.length - 1) {
            showChunks++;
            message.text += chunks[showChunks] + " ";
            waitTime = StringTools.contains(chunks[showChunks], ".") ? punctionTime : pauseTime;
        } else {
            if(choiceMessages.length > 0) {
                for(i in 0...choices.length)
                    choiceMessages[i].text = choices[i];

                if(Key.isPressed(Key.NUMBER_1)) {
                    choice = 0;
                    done = true;
                }
                if(Key.isPressed(Key.NUMBER_2)) {
                    choice = 1;
                    done = true;
                }
                if(Key.isPressed(Key.NUMBER_3)) {
                    choice = 2;
                    done = true;
                }
                if(Key.isPressed(Key.NUMBER_4)) {
                    choice = 3;
                    done = true;
                }
            } else {
                if(Key.isDown(Key.SPACE)) {
                    choice = -1;
                    done = true;
                }
            }
        }
        dtAccum = 0.;
    }
}

var chatBox: Chatbox;

class Main extends hxd.App {
    var runner = new NSRunner();

    override function init() {
        chatBox = new Chatbox(s2d);
        chatBox.start("Hello Traveler. Welcome to my shop.");
        runner.start(script);
    }

    override function update(dt: Float) { 
        chatBox.update(dt);
    }

    static function main() {
        new Main();
    }
}

// typedef Status = {
//     var done: Bool;
//     var choice: Int;
// }

// function say(msg: String) {
//     chatBox.start(msg);
//     return () -> {
//         return {}
//     }

//      // start saying.
//      // When typing is complete, said = true;
//      // When choice is made, choise = true;   
// }

// class WaitChunk {
//     public var lines: Array<String>;
// }

// class Chunk {
//     var startLine: Int;
//     var done: Bool;
// }

class NSRunner {
    // Core Runner Vars
    public var running = false;
    public var lines: Array<String>;
    var expr: Expr;
    var parser = new hscript.Parser();
    var interp = new hscript.Interp();

    var canProceed: () -> Bool;

    public function new (){}

    public function start(script: String) {
        // break hscript into chunks
        running = true;
        lines = script.split("\n");
        trace(lines.length);

        // Bind to hscript
    }

    public function step() {
        expr = parser.parseString("");
    }
}