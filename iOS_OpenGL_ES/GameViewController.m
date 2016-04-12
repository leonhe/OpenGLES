//
//  GameViewController.m
//  iOS_OPenGL_ES
//
//  Created by Yuanfei He on 16/4/12.
//  Copyright © 2016年 Yuanfei He. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))
// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

//static GLfloat interwinded[]={
//    -1.0f,-1.0f,0.0f,
//    1.0f,-1.0f,0.0f,
//    0.0f,1.0f,0.0f,
//};

static GLfloat interwinded[] = {
    -1.0f,-1.0f,-1.0f, // triangle 1 : begin
    -1.0f,-1.0f, 1.0f,
    -1.0f, 1.0f, 1.0f, // triangle 1 : end
    1.0f, 1.0f,-1.0f, // triangle 2 : begin
    -1.0f,-1.0f,-1.0f,
    -1.0f, 1.0f,-1.0f, // triangle 2 : end
    1.0f,-1.0f, 1.0f,
    -1.0f,-1.0f,-1.0f,
    1.0f,-1.0f,-1.0f,
    1.0f, 1.0f,-1.0f,
    1.0f,-1.0f,-1.0f,
    -1.0f,-1.0f,-1.0f,
    -1.0f,-1.0f,-1.0f,
    -1.0f, 1.0f, 1.0f,
    -1.0f, 1.0f,-1.0f,
    1.0f,-1.0f, 1.0f,
    -1.0f,-1.0f, 1.0f,
    -1.0f,-1.0f,-1.0f,
    -1.0f, 1.0f, 1.0f,
    -1.0f,-1.0f, 1.0f,
    1.0f,-1.0f, 1.0f,
    1.0f, 1.0f, 1.0f,
    1.0f,-1.0f,-1.0f,
    1.0f, 1.0f,-1.0f,
    1.0f,-1.0f,-1.0f,
    1.0f, 1.0f, 1.0f,
    1.0f,-1.0f, 1.0f,
    1.0f, 1.0f, 1.0f,
    1.0f, 1.0f,-1.0f,
    -1.0f, 1.0f,-1.0f,
    1.0f, 1.0f, 1.0f,
    -1.0f, 1.0f,-1.0f,
    -1.0f, 1.0f, 1.0f,
    1.0f, 1.0f, 1.0f,
    -1.0f, 1.0f, 1.0f,
    1.0f,-1.0f, 1.0f
};

//static GLfloat color_val[]={
//    1.0f,0.0f,0.0f,1.0f,
//    1.0f,0.0f,1.0f,1.0f,
//    0.0f,0.0f,1.0f,1.0f,
//};


static  GLfloat color_val[] = {
    0.583f, 0.771f, 0.014f,1.0f,
    0.609f, 0.115f, 0.436f,1.0f,
    0.327f, 0.483f, 0.844f,1.0f,
    0.822f, 0.569f, 0.201f,1.0f,
    0.435f, 0.602f, 0.223f,1.0f,
    0.310f, 0.747f, 0.185f,1.0f,
    0.597f, 0.770f, 0.761f,1.0f,
    0.559f, 0.436f, 0.730f,1.0f,
    0.359f, 0.583f, 0.152f,1.0f,
    0.483f, 0.596f, 0.789f,1.0f,
    0.559f, 0.861f, 0.639f,1.0f,
    0.195f, 0.548f, 0.859f,1.0f,
    0.014f, 0.184f, 0.576f,1.0f,
    0.771f, 0.328f, 0.970f,1.0f,
    0.406f, 0.615f, 0.116f,1.0f,
    0.676f, 0.977f, 0.133f,1.0f,
    0.971f, 0.572f, 0.833f,1.0f,
    0.140f, 0.616f, 0.489f,1.0f,
    0.997f, 0.513f, 0.064f,1.0f,
    0.945f, 0.719f, 0.592f,1.0f,
    0.543f, 0.021f, 0.978f,1.0f,
    0.279f, 0.317f, 0.505f,1.0f,
    0.167f, 0.620f, 0.077f,1.0f,
    0.347f, 0.857f, 0.137f,1.0f,
    0.055f, 0.953f, 0.042f,1.0f,
    0.714f, 0.505f, 0.345f,1.0f,
    0.783f, 0.290f, 0.734f,1.0f,
    0.722f, 0.645f, 0.174f,1.0f,
    0.302f, 0.455f, 0.848f,1.0f,
    0.225f, 0.587f, 0.040f,1.0f,
    0.517f, 0.713f, 0.338f,1.0f,
    0.053f, 0.959f, 0.120f,1.0f,
    0.393f, 0.621f, 0.362f,1.0f,
    0.673f, 0.211f, 0.457f,1.0f,
    0.820f, 0.883f, 0.371f,1.0f,
    0.982f, 0.099f, 0.879f,1.0f,
};

@interface GameViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _colorBuffer;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    for (int i=0; i<108; i++) {
        GLfloat value = interwinded[i];
        interwinded[i]=(GLfloat)(value*0.3);
    }
    
    [self loadShaders];
    
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_LESS);
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(interwinded), interwinded, GL_STATIC_DRAW);
    
        glGenBuffers(1, &_colorBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(color_val), color_val, GL_STATIC_DRAW);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0f), aspect, 0.1f, 100.0f);
    
    
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    
     _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // Drawing code here.

    
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE,0, BUFFER_OFFSET(0));
    glDrawArrays(GL_TRIANGLES, 0, 12*3);
    glDisableVertexAttribArray(0);
    
    glEnableVertexAttribArray(1);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    glUseProgram(_program); //use link programe
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);

//     glDisableVertexAttribArray(1);
    glFlush();

    
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"vertexShader" ofType:@"vsh" inDirectory:@"Shaders"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"fragmenShader" ofType:@"fsh" inDirectory:@"Shaders"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
//    glBindAttribLocation(_program, 1, "color");
    
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
//    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
