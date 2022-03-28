#pragma once

#ifndef CUSTOMPLUGIN_H
#define CUSTOMPLUGIN_H
#endif // CUSTOMPLUGIN_H

#include "QGCCorePlugin.h"

class CustomPlugin : public QGCCorePlugin {
    Q_OBJECT;

  public:
    CustomPlugin(QGCApplication *app, QGCToolbox *toolbox);
    ~CustomPlugin();
};