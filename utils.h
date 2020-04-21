#ifndef UTILS_H
#define UTILS_H

enum TLSocketType {
    NULL_TYPE = 0,
    TERGEO_GUI = 1,
    TERGEO_APP = 2
};

enum MessageType {
    MESSAGE_UNKNOWN = 0,
    MESSAGE_NEW_DEIVCE_CONNECT = 1,
    MESSAGE_VEHICLE_WIDTH_HEIGHT = 2,

    MESSAGE_LOGIN = 10,
    MESSAGE_LOGIN_RST = 11,
    MESSAGE_UPDATE_ACCOUNT = 12,
    MESSAGE_UPDATE_ACCOUNT_RST = 13,
    MESSAGE_ADD_ACCOUNT = 14,
    MESSAGE_ADD_ACCOUNT_RST = 15,
    MESSAGE_DELETE_ACCOUNT = 16,
    MESSAGE_DELETE_ACCOUNT_RST = 17,
    MESSAGE_ALL_ACCOUNTS_INFO = 18,

    MESSAGE_ALL_MAPS_INFO = 100,
    MESSAGE_SET_MAP = 101,
    MESSAGE_SET_MAP_RST = 102,
    MESSAGE_SET_INIT_POSE = 103,
    MESSAGE_SET_INIT_POSE_RST = 104,
    MESSAGE_CURRENT_MAP_AND_TASKS = 105,
    MESSAGE_CURRENT_MAP_AND_TASKS_RST = 106,
    MESSAGE_TASKS_INFO = 107,
    MESSAGE_SET_TASKS = 108,
    MESSAGE_SET_TASKS_RST = 109,
    MESSAGE_CURRENT_WORK_MAP_DATA = 110,
    MESSAGE_CURRENT_WORK_MAP_DATA_RST = 111,
    MESSAGE_PAUSE_TASK = 112,
    MESSAGE_PAUSE_TASK_RST = 113,
    MESSAGE_STOP_TASK = 114,
    MESSAGE_STOP_TASK_RST = 115,
    MESSAGE_RETURN_TO_SLECT_MAP = 116,
    MESSAGE_WORK_DOWN = 117,
    MESSAGE_WORK_ERROR = 118,

    MESSAGE_CURRENT_WORK_FULL_REF_LINE = 200,
    MESSAGE_TASK_INFO = 201,
    MESSAGE_LOCALIZATION_INFO = 202,
    MESSAGE_CHASSIS_INFO = 203,
    MESSAGE_PERCEPTION_OBSTACLES = 204,
    MESSAGE_PLANNING_COMMAND_PATH = 205,
    MESSAGE_PLANNING_REF_LINE =206,
    MESSAGE_BATTERY_SOC = 207,
    MESSAGE_TRAJECTORY = 208,
    MESSAGE_MONITOR_MESSAGE = 209,
    MESSAGE_SORT_MESSAGE = 210
};

enum PermissionLevel {
    PERMISSION_UNKONWN = 0,
    PERMISSION_NORMAL = 1,
    PERMISSION_ADMIN = 2,
    PERMISSION_ROOT = 3
};

enum WorkStatus {
    WORK_STATUS_NONE_WORK = 0,
    WORK_STATUS_MAP_SELECTED_NOT_LOCATING = 1,
    WORK_STATUS_MAP_SELECTED_LOCATING = 2,
    WORK_STATUS_TASK_SELECTED = 3,
    WORK_STATUS_WORKING = 4
};
#endif // UTILS_H
