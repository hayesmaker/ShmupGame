// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display
{
    import flash.media.Sound;
    
    import starling.animation.IAnimatable;
    import starling.events.Event;
    import starling.textures.Texture;
    
    /** Dispatched whenever the movie has displayed its last frame. */
    [Event(name="movieCompleted", type="starling.events.Event")]
    
    /** A MovieClip is a simple way to display an animation depicted by a list of textures.
     *  
     *  <p>Pass the frames of the movie in a vector of textures to the constructor. The movie clip 
     *  will have the width and height of the first frame. If you group your frames with the help 
     *  of a texture atlas (which is recommended), use the <code>getTextures</code>-method of the 
     *  atlas to receive the textures in the correct (alphabetic) order.</p> 
     *  
     *  <p>You can specify the desired framerate via the constructor. You can, however, manually 
     *  give each frame a custom duration. You can also play a sound whenever a certain frame 
     *  appears.</p>
     *  
     *  <p>The methods <code>play</code> and <code>pause</code> control playback of the movie. You
     *  will receive an event of type <code>Event.MovieCompleted</code> when the movie finished
     *  playback. If the movie is looping, the event is dispatched once per loop.</p>
     *  
     *  <p>As any animated object, a movie clip has to be added to a juggler (or have its 
     *  <code>advanceTime</code> method called regularly) to run.</p>
     *  
     *  @see starling.textures.TextureAtlas
     */    
    public class MovieClip extends Image implements IAnimatable
    {
        private var mTextures:Vector.<Texture>;
        private var mSounds:Vector.<Sound>;
        private var mDurations:Vector.<Number>;
        
        private var mDefaultFrameDuration:Number;
        private var mTotalTime:Number;
        private var mCurrentTime:Number;
        private var mCurrentFrame:int;
        private var mLoop:Boolean;
        private var mPlaying:Boolean;
        
        /** Creates a moviclip from the provided textures and with the specified default framerate.
         *  The movie will have the size of the first frame. */  
        public function MovieClip(textures:Vector.<Texture>, fps:Number=12)
        {            
            if (textures.length > 0)
            {
                super(textures[0]);
                mDefaultFrameDuration = 1.0 / fps;
                mLoop = true;
                mPlaying = true;
                mTotalTime = 0.0;
                mCurrentTime = 0.0;
                mCurrentFrame = 0;
                mTextures = new <Texture>[];
                mSounds = new <Sound>[];
                mDurations = new <Number>[];
                
                for each (var texture:Texture in textures)
                    addFrame(texture);
            }
            else
            {
                throw new ArgumentError("Empty texture array");
            }
        }
        
        // frame manipulation
        
        /** Adds an additional frame, optionally with a sound and a custom duration. If the 
         *  duration is omitted, the default framerate is used (as specified in the constructor). */   
        public function addFrame(texture:Texture, sound:Sound=null, duration:Number=-1):void
        {
            addFrameAt(numFrames, texture, sound, duration);
        }
        
        /** Adds a frame at a certain index, optionally with a sound and a custom duration. */
        public function addFrameAt(frameID:int, texture:Texture, sound:Sound=null, 
                                   duration:Number=-1):void
        {
            if (frameID < 0 || frameID > numFrames) throw new ArgumentError("Invalid frame id");
            if (duration < 0) duration = mDefaultFrameDuration;
            mTextures.splice(frameID, 0, texture);
            mSounds.splice(frameID, 0, sound);
            mDurations.splice(frameID, 0, duration);
            mTotalTime += duration;
        }
        
        /** Removes the frame at a certain ID. The successors will move down. */
        public function removeFrameAt(frameID:int):void
        {
            if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
            mTotalTime -= getFrameDuration(frameID);
            mTextures.splice(frameID, 1);
            mSounds.splice(frameID, 1);
            mDurations.splice(frameID, 1);
        }
        
        /** Returns the texture of a certain frame. */
        public function getFrameTexture(frameID:int):Texture
        {
            if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
            return mTextures[frameID];
        }
        
        /** Sets the texture of a certain frame. */
        public function setFrameTexture(frameID:int, texture:Texture):void
        {
            if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
            mTextures[frameID] = texture;
        }
        
        /** Returns the sound of a certain frame. */
        public function getFrameSound(frameID:int):Sound
        {
            if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
            return mSounds[frameID];
        }
        
        /** Sets the sound of a certain frame. The sound will be played whenever the frame 
         *  is displayed. */
        public function setFrameSound(frameID:int, sound:Sound):void
        {
            if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
            mSounds[frameID] = sound;
        }
        
        /** Returns the duration of a certain frame (in seconds). */
        public function getFrameDuration(frameID:int):Number
        {
            if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
            return mDurations[frameID];
        }
        
        /** Sets the duration of a certain frame (in seconds). */
        public function setFrameDuration(frameID:int, duration:Number):void
        {
            if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
            mTotalTime -= getFrameDuration(frameID);
            mTotalTime += duration;
            mDurations[frameID] = duration;
        }
        
        // helper methods
        
        private function updateCurrentFrame():void
        {
            texture = mTextures[mCurrentFrame];
        }
        
        private function playCurrentSound():void
        {
            var sound:Sound = mSounds[mCurrentFrame];
            if (sound) sound.play();
        }
        
        // playback methods
        
        /** Starts playback. Beware that the clip has to be added to a juggler, too! */
        public function play():void
        {
            mPlaying = true;
        }
        
        /** Pauses playback. */
        public function pause():void
        {
            mPlaying = false;
        }
        
        /** Stops playback, resetting "currentFrame" to zero. */
        public function stop():void
        {
            mPlaying = false;
            currentFrame = 0;
        }
        
        // IAnimatable
        
        /** @inheritDoc */
        public function advanceTime(passedTime:Number):void
        {
            if (mLoop && mCurrentTime == mTotalTime) mCurrentTime = 0.0;
            if (!mPlaying || passedTime == 0.0 || mCurrentTime == mTotalTime) return;
            
            var i:int = 0;
            var durationSum:Number = 0.0;
            var previousTime:Number = mCurrentTime;
            var restTime:Number = mTotalTime - mCurrentTime;
            var carryOverTime:Number = passedTime > restTime ? passedTime - restTime : 0.0;
            mCurrentTime = Math.min(mTotalTime, mCurrentTime + passedTime);
            
            for each (var duration:Number in mDurations)
            {
                if (durationSum + duration >= mCurrentTime)
                {
                    if (mCurrentFrame != i)
                    {
                        mCurrentFrame = i;
                        updateCurrentFrame();
                        playCurrentSound();
                    }
                    break;
                }
                
                ++i;
                durationSum += duration;
            }
            
            if (previousTime < mTotalTime && mCurrentTime == mTotalTime &&
                hasEventListener(Event.MOVIE_COMPLETED))
            {
                dispatchEvent(new Event(Event.MOVIE_COMPLETED));
            }
                
            advanceTime(carryOverTime);
        }
        
        /** Always returns <code>false</code>. */
        public function get isComplete():Boolean 
        {
            return false;
        }
        
        // properties  
        
        /** The total duration of the clip in seconds. */
        public function get totalTime():Number { return mTotalTime; }
        
        /** The total number of frames. */
        public function get numFrames():int { return mTextures.length; }
        
        /** Indicates if the clip should loop. */
        public function get loop():Boolean { return mLoop; }
        public function set loop(value:Boolean):void { mLoop = value; }
        
        /** The index of the frame that is currently displayed. */
        public function get currentFrame():int { return mCurrentFrame; }
        public function set currentFrame(value:int):void
        {
            mCurrentFrame = value;
            mCurrentTime = 0.0;
            
            for (var i:int=0; i<value; ++i)
                mCurrentTime += getFrameDuration(i);
            
            updateCurrentFrame();
        }
        
        /** The default number of frames per second. Individual frames can have different 
         *  durations. If you change the fps, the durations of all frames will be scaled 
         *  relatively to the previous value. */
        public function get fps():Number { return 1.0 / mDefaultFrameDuration; }
        public function set fps(value:Number):void
        {
            var newFrameDuration:Number = value == 0.0 ? Number.MAX_VALUE : 1.0 / value;
            var acceleration:Number = newFrameDuration / mDefaultFrameDuration;
            mCurrentTime *= acceleration;
            mDefaultFrameDuration = newFrameDuration;
            
            for (var i:int=0; i<numFrames; ++i)
                setFrameDuration(i, getFrameDuration(i) * acceleration);
        }
        
        /** Indicates if the clip is still playing. Returns <code>false</code> when the end 
         *  is reached. */
        public function get isPlaying():Boolean 
        {
            if (mPlaying)
                return mLoop || mCurrentTime < mTotalTime;
            else
                return false;
        }
    }
}