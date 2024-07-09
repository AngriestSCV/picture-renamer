.pragma library

function stripPrefix(prefix, target) {
    if(target.startsWith(prefix)){
        target = target.substring(prefix.length);
    }
    return target;
}

