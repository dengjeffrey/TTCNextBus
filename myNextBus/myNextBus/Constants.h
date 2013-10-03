//
//  Constants.h
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-20.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

typedef enum {
    Left,
    Right,
    Up,
    Down
} ViewOrientation;

typedef void(^completion)(BOOL finished);