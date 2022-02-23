/********************************************************************
 KWin - the KDE window manager
 This file is part of the KDE project.

 Copyright (C) 2013 Martin Gräßlin <mgraesslin@kde.org>
 Copyright (C) 2013 Kai Uwe Broulik <kde@privat.broulik.de>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
/*global effect, effects, animate, animationTime, Effect, QEasingCurve*/
var zoomDesktopEffect = {
    // This is double the animation time lightdm's greeter uses when
    // fading out its input controls
    duration: animationTime(800),
    loadConfig: function () {
        "use strict";
        zoomDesktopEffect.duration = animationTime(800);
    },
    isPanel: function (window) {
        "use strict";
        // there is no .contains() in ecmascript ...
        if (window.dock && window.windowRole.indexOf('panel') !== -1) { return true; }
        return false;
    },
    fadeDesktop: function (window, direction) {
        "use strict";
        animate({
            window: window,
            duration: zoomDesktopEffect.duration,
            animations: [{
                type: Effect.Opacity,
                curve: QEasingCurve.InOutQuad,
                from: direction === 'in' ? 0.0 : 1.0,
                to: direction === 'in' ? 1.0 : 0.0
            }, {
                type: Effect.Scale,
                curve: QEasingCurve.InOutQuad,
                from: direction === 'in' ? 0.75 : 1.0,
                to: direction === 'in' ? 1.0 : 1.5
            }]
        });
    },
    fadePanel: function (window, direction) {
        "use strict";
        animate({
            window: window,
            duration: zoomDesktopEffect.duration,
            animations: [{
                type: Effect.Opacity,
                from: 0.0,
                to: 0.0
            }, {
                type: Effect.Opacity,
                curve: QEasingCurve.InOutQuad,
                from: direction === 'in' ? 0.0 : 1.0,
                to: direction === 'in' ? 1.0 : 0.0,
                delay: direction === 'in' ? zoomDesktopEffect.duration : 0
            }]
        });
    },
    shown: function (window) {
        "use strict";
        if (window.desktopWindow) {
            zoomDesktopEffect.fadeDesktop(window, 'in');
        } else if (zoomDesktopEffect.isPanel(window)) {
            zoomDesktopEffect.fadePanel(window, 'in');
        }
    },
    closed: function (window) {
        "use strict";
        if (window.desktopWindow) {
            zoomDesktopEffect.fadeDesktop(window, 'out');
        // Animating panel disappearance causes some strange interferences with slidingpopups effect
        //} else if (window.dock) {
        //    zoomDesktopEffect.fadePanel(window,'out');
        }
    },
    init: function () {
        "use strict";
        effect.configChanged.connect(zoomDesktopEffect.loadConfig);
        effects.windowAdded.connect(zoomDesktopEffect.shown);
        effects.windowClosed.connect(zoomDesktopEffect.closed);
    }
};
zoomDesktopEffect.init();