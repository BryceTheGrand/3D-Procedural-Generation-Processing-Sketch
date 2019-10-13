import peasy.*;

final int RESX = 300;
final int RESY = 300;

final float SNOWCAPTHRESHOLD  = 0.7;
final float MOUNTAINTHRESHOLD = 0.65;
final float LANDTHRESHOLD     = 0.55;
final float BEACHTHRESHOLD    = 0.52;
final float SHALLOWTHRESHOLD  = 0.45;

final float LAYERONEEMPHASIS   = 1;
final float LAYERTWOEMPHASIS   = 0.3;
final float LAYERTHREEEMPHASIS = 0.05;

final int LAYERONECHAOS   = 5;
final int LAYERTWOCHAOS   = 15;
final int LAYERTHREECHAOS = 50;

float[][] mapToUse;

final int TABLEHEIGHT = 200;

boolean autoOffset = false;

PeasyCam camera;

void setup() {
    size(800, 800, P3D);
    camera = new PeasyCam(this, width / 2, height / 1.5, 100, 400);
    camera.setMinimumDistance(10);
    camera.setMaximumDistance(2000);
    mapToUse = getNewSeeds();
}

void drawMap(float[][] map) {
    noStroke();
    strokeWeight(8);
    float[] scale = new float[] {(float)width / map.length, (float)height / map[0].length};
    for (int x = 0; x < map.length; x++) {
        for (int y = 0; y < map[x].length; y++) {

            float noiseValue = map[x][y];

            // COLOURS stroke (3D) edition ;)
            findColour(noiseValue);

            point(x * scale[0], y * scale[1], (noiseValue > BEACHTHRESHOLD) ? noiseValue * TABLEHEIGHT : TABLEHEIGHT * BEACHTHRESHOLD + noiseValue);
        }
    }
}

void findColour(float n) {
    if (n > SNOWCAPTHRESHOLD) {
        stroke(230, 230, 230);
    } else if (n > MOUNTAINTHRESHOLD) {
        stroke(100, 100, 125);
    } else if (n > LANDTHRESHOLD) {
        stroke(50, 255, 125);
    } else if (n > BEACHTHRESHOLD) {
        stroke(200, 255, 50);
    } else if (n > SHALLOWTHRESHOLD) {
        stroke(30, 90, 200);
    } else {
        stroke(15, 70, 200);
    }
}

float[][] sum(float[][][] maps) {
    float[][] total = new float[maps[0].length][];

    // fill with zeroes
    for (int x = 0; x < total.length; x++) {
        float[] column = new float[maps[0][0].length];
        for (int y = 0; y < column.length; y++) {

            column[y] = 0;
        }
        total[x] = column;
    }

    for (float[][] map : maps) {

        for (int x = 0; x < total.length; x++) {

            float[] column = new float[map[0].length];
            for (int y = 0; y < column.length; y++) {
                total[x][y] += map[x][y];
            }
        }
    }
    return total;
}

float[][] normalize(float[][] map, float max) {

    float[][] newMap = new float[map.length][];

    for (int x = 0; x < map.length; x++) {

        float[] column = new float[map[x].length];
        for (int y = 0; y < column.length; y++) {
            column[y] = map[x][y] / max;
        }
        newMap[x] = column;
    }

    return newMap;
}

float[][] getNewSeeds() {

    Noise mainLayer    = new Noise(RESX, RESY, LAYERONEEMPHASIS, LAYERONECHAOS);
    Noise boulderLayer = new Noise(RESX, RESY, LAYERTWOEMPHASIS, LAYERTWOCHAOS);
    Noise pebbleLayer  = new Noise(RESX, RESY, LAYERTHREEEMPHASIS, LAYERTHREECHAOS);

    float maxValue = mainLayer.minimizer + boulderLayer.minimizer + pebbleLayer.minimizer;
    float[][] newMap = sum(new float[][][] {mainLayer.getNoiseMap(), 
        boulderLayer.getNoiseMap(), 
        pebbleLayer.getNoiseMap()});
    newMap = normalize(newMap, maxValue);
    return newMap;
}

void draw() {
    background(0);
    noStroke();
    drawMap(mapToUse);
}

void keyPressed() {

    if (key == 'r') {
        mapToUse = getNewSeeds();
    }
}
