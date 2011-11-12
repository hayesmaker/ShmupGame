// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures
{
    import flash.display3D.textures.TextureBase;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import starling.utils.VertexData;

    /** A SubTexture represents a section of another texture. This is achieved solely by 
     *  manipulation of texture coordinates, making the class very efficient. 
     *
     *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
     */ 
    public class SubTexture extends Texture
    {
        private var mParent:Texture;
        private var mClipping:Rectangle;
        private var mRootClipping:Rectangle;
        
        /** Creates a new subtexture containing the specified region (in pixels) of a parent 
         *  texture. */
        public function SubTexture(parentTexture:Texture, region:Rectangle)
        {
            mParent = parentTexture;
            this.clipping = new Rectangle(region.x / parentTexture.width,
                                          region.y / parentTexture.height,
                                          region.width / parentTexture.width,
                                          region.height / parentTexture.height);
        }
        
        /** @inheritDoc */
        public override function adjustVertexData(vertexData:VertexData):VertexData
        {
            var newData:VertexData = super.adjustVertexData(vertexData);
            var numVertices:int = vertexData.numVertices;
            
            var clipX:Number = mRootClipping.x;
            var clipY:Number = mRootClipping.y;
            var clipWidth:Number  = mRootClipping.width;
            var clipHeight:Number = mRootClipping.height;
            
            for (var i:int=0; i<numVertices; ++i)
            {
                var texCoords:Point = vertexData.getTexCoords(i);
                newData.setTexCoords(i, clipX + texCoords.x * clipWidth,
                                        clipY + texCoords.y * clipHeight);
            }
            
            return newData;
        }
        
        /** The texture which the subtexture is based on. */ 
        public function get parent():Texture { return mParent; }
        
        /** The clipping rectangle, which is the region provided on initialization 
         *  scaled into [0.0, 1.0]. */
        public function get clipping():Rectangle { return mClipping.clone(); }
        public function set clipping(value:Rectangle):void
        {
            mClipping = value.clone();
            mRootClipping = value.clone();
            
            var parentTexture:SubTexture = mParent as SubTexture;            
            while (parentTexture)
            {
                var parentClipping:Rectangle = parentTexture.mClipping;
                mRootClipping.x = parentClipping.x + mRootClipping.x * parentClipping.width;
                mRootClipping.y = parentClipping.y + mRootClipping.y * parentClipping.height;
                mRootClipping.width  *= parentClipping.width;
                mRootClipping.height *= parentClipping.height;
                parentTexture = parentTexture.mParent as SubTexture;
            }
        }
        
        /** @inheritDoc */
        public override function get base():TextureBase { return mParent.base; }
        
        /** @inheritDoc */
        public override function get width():Number { return mParent.width * mClipping.width; }
        
        /** @inheritDoc */
        public override function get height():Number { return mParent.height * mClipping.height; }
        
        /** @inheritDoc */
        public override function get mipMapping():Boolean { return mParent.mipMapping; }
        
        /** @inheritDoc */
        public override function get premultipliedAlpha():Boolean { return mParent.premultipliedAlpha; }
    }
}