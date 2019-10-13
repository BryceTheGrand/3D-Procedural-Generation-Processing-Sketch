class Noise {
    int resx;
    int resy;
    float minimizer;
    int scale;

    Noise(int resx, int resy, float minimizer) {
        this.resx = resx;
        this.resy = resy;
        this.minimizer = minimizer;
        this.scale = 5;
    }
    
    Noise(int resx, int resy, float minimizer, int scale) {
        this.resx = resx;
        this.resy = resy;
        this.minimizer = minimizer;
        this.scale = scale;
    }

    float[][] getNoiseMap() {
        noiseSeed((long) random(100000));
        float[][] map = new float[resx][resy];
        for (int x = 0; x < resx; x++) {
            float[] column = new float[resy];
            for (int y = 0; y < resy; y++) {
                column[y] = noise((float) scale * x / (resx), (float) scale * y / (resy)) * minimizer;
            }
            map[x] = column;
        }
        return map;
    }
}
